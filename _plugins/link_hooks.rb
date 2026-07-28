# _plugins/link_hooks.rb
#
# Single :post_render pass over the finished page. Three jobs:
#
#   1. Mint link-* ids on citing links (feeds scripts/generate_backlinks.rb).
#   2. Insert the Footnotes heading pandoc's writer cannot emit.
#   3. Add heading self-links and, where a #TOC container exists, fill it.
#
# Jobs 2 and 3a are page-level apparatus and run on every page. Only the TOC
# list itself depends on the container, which post.html emits under page.toc.
#
# Identifier authority is pandoc. Nothing here mints a section or heading id;
# ids are read from the `section[id]` elements section_divs produces. The
# footnotes heading is the sole insertion, and it borrows the id pandoc
# already put on the enclosing section.

require 'nokogiri'

module LinkHooks
  HEADINGS = %w[h1 h2 h3 h4 h5 h6].freeze
  HEADING_SELECTOR = HEADINGS.join(',').freeze

  def self.process(item)
    return unless item.output_ext == ".html"
    return if item.output.nil? || item.output.empty?

    doc = Nokogiri::HTML(item.output)
    modified = false

    modified |= inject_link_ids(item, doc)
    modified |= decorate_sections(item, doc)

    item.output = doc.to_html if modified
  rescue => e
    Jekyll.logger.error "LinkHooks:", "Error processing #{item.path}: #{e.message}"
  end

  # --- 1. citing-link anchors -------------------------------------------

  def self.inject_link_ids(item, doc)
    excluded = (item.site.config.dig('backlinks', 'excluded_id_elements') || [])
    counts = Hash.new(0)
    modified = false

    doc.css('a[href^="/"]').each do |link|
      next if link['id']
      next if in_excluded_element?(link, excluded)

      base = generate_link_id(link['href'])
      counts[base] += 1
      link['id'] = counts[base] == 1 ? base : "#{base}-#{counts[base]}"
      modified = true
    end

    modified
  end

  # --- 2 & 3. footnotes heading, self-links, TOC -------------------------

  def self.decorate_sections(item, doc)
    root = doc.at_css('#markdownBody')
    return false unless root

    modified = add_footnotes_heading(root, doc)

    # Always walked: this is what mints heading self-links, which have no
    # relation to the TOC. Returns the section tree for the list below.
    max_level = (item.site.config.dig('toc', 'max_level') || 6).to_i
    entries = walk(root, doc, 1, max_level, {})
    modified = true unless entries.empty?

    container = doc.at_css('#TOC')
    return modified unless container

    # Defensive: post.html gates the container on page.toc, so this only fires
    # if some other layout emits one unconditionally.
    unless item.data['toc']
      container.remove
      return true
    end

    # #backlinks is authored in post.html, a sibling of #markdownBody, so it
    # cannot be reached from the scan root — which is also why backlink
    # snippets can never leak their quoted headings into this TOC. Appended
    # explicitly, and only when the snippet actually rendered. The snippet
    # nests its own heading inside .backlinks-container, so this is a
    # descendant search, not a child search.
    bl = doc.at_css('section#backlinks')
    if bl && bl.element_children.any?
      label = bl.at_css(HEADING_SELECTOR)&.text.to_s.strip
      label = 'Backlinks' if label.empty?
      entries << { id: 'backlinks', label: label, children: [] }
    end

    if entries.empty?
      container.remove
    else
      container.inner_html = render_list(entries, 1)
    end

    true
  end

  # Footnotes: pandoc's HTML writer emits <section id="footnotes"> with no
  # heading, at serialization time. No AST node exists, so no Lua filter can
  # reach it. This is the only stage at which it can be titled.
  def self.add_footnotes_heading(root, doc)
    fn = root.at_css('> section#footnotes') || root.at_css('section#footnotes')
    return false unless fn
    return false if fn.element_children.any? { |e| HEADINGS.include?(e.name) }

    h = Nokogiri::XML::Node.new('h2', doc)
    h.content = 'Footnotes'
    hr = fn.at_css('> hr')
    hr ? hr.add_next_sibling(h) : fn.children.first&.add_previous_sibling(h) || fn.add_child(h)
    true
  end

  # Recursive descent. Pandoc nests <section> by heading level, so the DOM is
  # already the TOC tree — no h_num arithmetic, no flat-list reconstruction.
  def self.walk(node, doc, depth, max_level, seen)
    return [] if depth > max_level

    node.element_children.each_with_object([]) do |el, out|
      next unless el.name == 'section'
      id = el['id']
      next if id.nil? || id.empty?

      heading = el.element_children.find { |e| HEADINGS.include?(e.name) }
      next unless heading

      label = heading.text.strip
      next if label.empty?

      # Duplicate ids mean the page was assembled from pre-rendered fragments
      # (diaries.html, podcast.html). Listing them twice would produce a TOC
      # whose links all resolve to the first occurrence. Skip and warn.
      if seen[id]
        Jekyll.logger.warn "LinkHooks:", "duplicate section id '#{id}' — skipped in TOC"
        next
      end
      seen[id] = true

      add_self_link(heading, id, doc)

      out << {
        id: id,
        label: label,
        children: walk(el, doc, depth + 1, max_level, seen)
      }
    end
  end

  # What anchor_headings.html did, minus the id minting: the href comes from
  # the id pandoc put on the enclosing section.
  def self.add_self_link(heading, id, doc)
    return if heading.element_children.any? { |e| e.name == 'a' && e['class'].to_s.split.include?('anchor') }

    a = Nokogiri::XML::Node.new('a', doc)
    a['class'] = 'anchor'
    a['href'] = "##{id}"
    heading.children.to_a.each { |c| a.add_child(c) }
    heading.add_child(a)
  end

  def self.render_list(entries, depth)
    items = entries.map do |e|
      sub = e[:children].empty? ? '' : render_list(e[:children], depth + 1)
      %(<li class="toc-entry toc-level-#{depth}"><a href="##{e[:id]}">#{e[:label]}</a>#{sub}</li>)
    end
    cls = depth == 1 ? ' class="section-nav"' : ''
    "<ul#{cls}>\n#{items.join("\n")}\n</ul>"
  end

  # --- shared helpers ---------------------------------------------------

  def self.in_excluded_element?(link, selectors)
    selectors.any? do |selector|
      if selector.start_with?('#')
        id = selector[1..]
        link.ancestors.any? { |el| el['id'] == id }
      elsif selector.start_with?('.')
        cls = selector[1..]
        link.ancestors.any? do |el|
          el['class'] && el['class'].split.include?(cls)
        end
      else
        link.ancestors.any? { |el| el.name == selector }
      end
    end
  end

  def self.generate_link_id(url)
    path = url.split('#')[0].split('?')[0]
    path = path[1..-1] if path.start_with?('/')

    id = path.gsub('/', '-').gsub(/[^\w\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-')
    id = "link-#{id}"

    if url.include?('#')
      fragment = url.split('#')[1]
      fragment = fragment.gsub(/[^\w\s-]/, '').gsub(/\s+/, '-')
      id += "-#{fragment}" unless fragment.empty?
    end

    id
  end
end

Jekyll::Hooks.register [:documents, :pages], :post_render do |item|
  LinkHooks.process(item)
end
