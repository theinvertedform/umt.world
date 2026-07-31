# _plugins/link_hooks.rb
#
# Single :post_render pass over the finished page. Four jobs:
#
#   1. Mint link-* ids on citing links (feeds scripts/generate_backlinks.rb).
#   2. Insert the Footnotes heading pandoc's writer cannot emit.
#   3. Add heading self-links and, where a #TOC container exists, fill it.
#   4. Wrap section-opening initials in a dropcap span.
#
# Jobs 2 and 3a are page-level apparatus and run on every page. Only the TOC
# list itself depends on the container, which post.html emits under page.toc.
# Job 4 is gated on the `dropcaps` frontmatter key and defaults to `opener`.
#
# Identifier authority is pandoc. Nothing here mints a section or heading id;
# ids are read from the `section[id]` elements section_divs produces. The
# footnotes heading is the sole insertion, and it borrows the id pandoc
# already put on the enclosing section. Job 4 mints class names only.

require 'nokogiri'
require 'cgi'

module LinkHooks
  HEADINGS = %w[h1 h2 h3 h4 h5 h6].freeze
  HEADING_SELECTOR = HEADINGS.join(',').freeze

  # --- TOC configuration ------------------------------------------------

  TOC_DEFAULT_MAX_LEVEL = 6

  # --- dropcap configuration --------------------------------------------

  DROPCAP_MODES = %w[opener sections none].freeze
  DROPCAP_DEFAULT_MODE = 'opener'.freeze

  # Sections that are apparatus, not prose. section_divs gives the inserted
  # Bibliography header a level2 section exactly like a real one, so an id
  # denylist is the only discriminator available.
  DROPCAP_EXCLUDED_SECTIONS = %w[footnotes bibliography refs backlinks].freeze

  # Block preamble a dropcap steps over to reach the first real paragraph.
  # Gwern's equivalent is the `.epigraph:first-child + p` selector.
  DROPCAP_PREAMBLE = %w[blockquote figure aside].freeze
  DROPCAP_PREAMBLE_CLASSES = %w[epigraph abstract front-matter].freeze
  DROPCAP_PREAMBLE_LIMIT = 3

  # Leading whitespace, optional opening quote/bracket, then the initial.
  # [A-Z0-9] only: the Chandler subset carries U+0030-0039, U+0041-005A and
  # the curly quotes, nothing else. A lowercase opener would fall through to
  # the fallback face, so it is skipped rather than transformed.
  DROPCAP_LEAD = /\A(\s*)(["'“”‘’(\[]*)([A-Z0-9])/.freeze

  # Inline apparatus stepped OVER: it renders in the margin or as a reference
  # mark, so the prose still begins at a following sibling.
  DROPCAP_INLINE_SKIP = %w[marginnote sidenote footnote-ref].freeze

  # Inline wrappers descended INTO: their content is prose, not apparatus. A
  # dropcap inside a small-caps opening is the Bringhurst arrangement, so the
  # cap is minted in place and the SCSS resets caps/transform on .dropcap.
  # Deliberately excludes em/i/a/strong: Chandler Medium has no italic, and a
  # cap inside an anchor would be part of the link.
  DROPCAP_INLINE_DESCEND = %w[smallcaps].freeze

  def self.process(item)
    return unless item.output_ext == ".html"
    return if item.output.nil? || item.output.empty?

    doc = Nokogiri::HTML(item.output)
    modified = false

    modified |= inject_link_ids(item, doc)
    modified |= decorate_sections(item, doc)
    modified |= add_dropcaps(item, doc)

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

    # Always walked, and always to full depth: this is what mints heading
    # self-links, which have no relation to the TOC. The depth cap belongs to
    # the rendered list alone — a page that hides its subsections from the TOC
    # still wants every heading addressable.
    entries = walk(root, doc, {})
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
      container.inner_html = render_list(entries, 1, toc_max_level(item))
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
  def self.walk(node, doc, seen)
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
        children: walk(el, doc, seen)
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

  # Depth cap on the rendered list. Resolution, in order:
  #
  #   page.toc_max_level  →  site.toc.max_level  →  TOC_DEFAULT_MAX_LEVEL
  #
  # The unit is *nesting depth of the section tree*, not heading level: walk
  # counts descent, so this key survives a change to shift-heading-level-by.
  # Same class of invariant as levelN — see ARCHITECTURE §4.5.
  #
  # Sibling key, not nested under `toc:`, which is a boolean gate read by
  # post.html; a mapping there would cost a page the ability to say `false`.
  def self.toc_max_level(item)
    raw = item.data['toc_max_level']
    raw = item.site.config.dig('toc', 'max_level') if raw.nil?
    return TOC_DEFAULT_MAX_LEVEL if raw.nil?

    level = raw.to_i
    if level < 1
      Jekyll.logger.warn "LinkHooks:", "invalid toc_max_level '#{raw}' in #{item.path} — using #{TOC_DEFAULT_MAX_LEVEL}"
      return TOC_DEFAULT_MAX_LEVEL
    end

    level
  end

  def self.render_list(entries, depth, max_level)
    items = entries.map do |e|
      sub =
        if depth >= max_level || e[:children].empty?
          ''
        else
          render_list(e[:children], depth + 1, max_level)
        end
      %(<li class="toc-entry toc-level-#{depth}"><a href="##{e[:id]}">#{e[:label]}</a>#{sub}</li>)
    end
    cls = depth == 1 ? ' class="section-nav"' : ''
    "<ul#{cls}>\n#{items.join("\n")}\n</ul>"
  end

  # --- 4. dropcaps ------------------------------------------------------
  #
  # `opener`   — one cap, on the first body paragraph after .front-matter.
  #              With section_divs, prose preceding the first heading is not
  #              wrapped in a <section>, so the untitled introduction is a run
  #              of bare <p> children of #markdownBody and is what this finds.
  # `sections` — one cap per top-level section. shift-heading-level-by:1 makes
  #              those section.level2. Deliberately never level3: a cap that
  #              fires at every sub-heading is over-use, not apparatus.
  # `none`     — off.

  def self.add_dropcaps(item, doc)
    mode = (item.data['dropcaps'] || DROPCAP_DEFAULT_MODE).to_s
    unless DROPCAP_MODES.include?(mode)
      Jekyll.logger.warn "LinkHooks:", "unknown dropcaps mode '#{mode}' in #{item.path} — skipped"
      return false
    end
    return false if mode == 'none'

    root = doc.at_css('#markdownBody')
    return false unless root

    targets =
      case mode
      when 'opener'   then [opener_paragraph(root)]
      when 'sections' then top_level_sections(root).map { |s| section_opener(s) }
      end

    targets.compact.map { |p| dropcap_paragraph(p, doc) }.any?
  end

  # Top-tier sections only, as direct children — not doc.css, which would also
  # match a nested level2 if one ever appeared.
  def self.top_level_sections(root)
    root.element_children.select { |el| el.name == 'section' && dropcap_section?(el) }
  end

  def self.dropcap_section?(el)
    return false unless el.name == 'section'
    return false if DROPCAP_EXCLUDED_SECTIONS.include?(el['id'].to_s)
    class_list(el).include?('level2')
  end

  def self.opener_paragraph(root)
    root.element_children.each do |el|
      next if HEADINGS.include?(el.name)
      next if skippable_preamble?(el)
      return el if el.name == 'p'
      return section_opener(el) if dropcap_section?(el)
      return nil
    end
    nil
  end

  # First prose paragraph of a section, stepping over a leading epigraph or
  # figure but refusing to hunt indefinitely.
  def self.section_opener(sec)
    sec.element_children
       .reject { |el| HEADINGS.include?(el.name) }
       .first(DROPCAP_PREAMBLE_LIMIT)
       .each do |el|
         return el if el.name == 'p'
         next if skippable_preamble?(el)
         break
       end
    nil
  end

  def self.skippable_preamble?(el)
    return true if DROPCAP_PREAMBLE.include?(el.name)
    (class_list(el) & DROPCAP_PREAMBLE_CLASSES).any?
  end

  # The opening quotation mark goes inside the span — Bringhurst §4.1.5 — which
  # is why the subset carries U+2018-201D. It also shifts the optical left edge
  # from the letter to the mark, so .dropcap-quoted exists to zero the per-letter
  # overhang in SCSS.
  def self.dropcap_paragraph(p, doc)
    return false if p.at_css('.dropcap')

    tnode = dropcap_text_node(p)
    return false unless tnode

    m = DROPCAP_LEAD.match(tnode.content)
    return false unless m

    space, quote, letter = m[1].to_s, m[2].to_s, m[3]
    rest = tnode.content[m.end(0)..].to_s

    classes = ['dropcap', "dropcap-#{letter}"]
    classes << 'dropcap-quoted' unless quote.empty?

    frag = doc.fragment(
      CGI.escapeHTML(space) +
      %(<span class="#{classes.join(' ')}">#{CGI.escapeHTML(quote + letter)}</span>) +
      CGI.escapeHTML(rest)
    )
    tnode.replace(frag)
    true
  end

  # First text node opening with a cappable initial. Steps over leading margin
  # apparatus, descends into prose-bearing inline wrappers, and refuses
  # everything else — so a paragraph opening in <em> or <a> is skipped rather
  # than given a cap Chandler cannot set or that would join a link.
  def self.dropcap_text_node(node)
    node.children.each do |n|
      if n.text?
        return n if DROPCAP_LEAD.match?(n.content)
        return nil unless n.content.strip.empty?
        next
      end
      return nil unless n.element?
      next if skippable_inline?(n)
      return dropcap_text_node(n) if descendable_inline?(n)
      return nil
    end
    nil
  end

  def self.skippable_inline?(el)
    return true if el.name == 'sup'
    (class_list(el) & DROPCAP_INLINE_SKIP).any?
  end

  def self.descendable_inline?(el)
    return false unless el.name == 'span'
    cls = class_list(el)
    return true if cls.empty?
    (cls & DROPCAP_INLINE_DESCEND).any?
  end

  # --- shared helpers ---------------------------------------------------

  def self.class_list(el)
    el['class'].to_s.split
  end

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
