# _plugins/post_render/toc.rb
#
# Job 3b — build the table of contents and fill the #TOC container.
#
# The container is emitted empty by post.html, gated on page.toc. This job
# fills it, or removes it when there is nothing to list. It depends on
# Footnotes having already run: a section with an id but no heading is skipped
# by the walk, so an untitled section#footnotes would silently leave the TOC.

module PostRender
  module Toc
    DEFAULT_MAX_LEVEL = 6
    BACKLINKS_ID = 'backlinks'.freeze
    BACKLINKS_FALLBACK_LABEL = 'Backlinks'.freeze

    def self.call(doc, item)
      container = doc.at_css('#TOC')
      return false unless container

      # Defensive: post.html gates the container on page.toc, so this only
      # fires if some other layout emits one unconditionally.
      unless item.data['toc']
        container.remove
        return true
      end

      root = doc.at_css('#markdownBody')
      return false unless root

      entries = walk(root, {})
      append_backlinks(entries, doc)

      if entries.empty?
        container.remove
      else
        container.inner_html = render(entries, 1, max_level(item))
      end

      true
    end

    # Recursive descent. Pandoc nests <section> by heading level, so the DOM
    # is already the TOC tree — no h_num arithmetic, no flat-list
    # reconstruction. The depth cap is applied at render, not here.
    def self.walk(node, seen)
      node.element_children.each_with_object([]) do |el, out|
        next unless el.name == 'section'

        id = el['id']
        next if id.nil? || id.empty?

        heading = el.element_children.find { |e| PostRender.heading?(e) }
        next unless heading

        label = heading.text.strip
        next if label.empty?

        # Duplicate ids mean the page was assembled from pre-rendered
        # fragments (podcast.html). Listing them twice would produce a TOC
        # whose links all resolve to the first occurrence.
        if seen[id]
          Jekyll.logger.warn 'PostRender:', "duplicate section id '#{id}' — skipped in TOC"
          next
        end
        seen[id] = true

        out << { id: id, label: label, children: walk(el, seen) }
      end
    end

    # #backlinks is authored in post.html, a sibling of #markdownBody, so it
    # cannot be reached from the scan root — which is also why backlink
    # snippets can never leak their quoted headings into this TOC. Appended
    # explicitly, and only when the snippet actually rendered. The snippet
    # nests its own heading inside .backlinks-container, so this is a
    # descendant search, not a child search.
    def self.append_backlinks(entries, doc)
      bl = doc.at_css("section##{BACKLINKS_ID}")
      return unless bl && bl.element_children.any?

      label = bl.at_css(PostRender::HEADING_SELECTOR)&.text.to_s.strip
      label = BACKLINKS_FALLBACK_LABEL if label.empty?

      entries << { id: BACKLINKS_ID, label: label, children: [] }
    end

    # Depth cap on the rendered list. Resolution, in order:
    #
    #   page.toc_max_level  →  site.toc.max_level  →  DEFAULT_MAX_LEVEL
    #
    # The unit is *nesting depth of the section tree*, not heading level: walk
    # counts descent, so this key survives a change to shift-heading-level-by.
    # Same class of invariant as levelN — see ARCHITECTURE §4.5.
    #
    # Sibling key, not nested under `toc:`, which is a boolean gate read by
    # post.html; a mapping there would cost a page the ability to say `false`.
    def self.max_level(item)
      raw = item.data['toc_max_level']
      raw = item.site.config.dig('toc', 'max_level') if raw.nil?
      return DEFAULT_MAX_LEVEL if raw.nil?

      level = raw.to_i
      if level < 1
        Jekyll.logger.warn 'PostRender:',
                           "invalid toc_max_level '#{raw}' in #{item.path} — using #{DEFAULT_MAX_LEVEL}"
        return DEFAULT_MAX_LEVEL
      end

      level
    end

    def self.render(entries, depth, max_level)
      items = entries.map do |e|
        sub =
          if depth >= max_level || e[:children].empty?
            ''
          else
            render(e[:children], depth + 1, max_level)
          end
        %(<li class="toc-entry toc-level-#{depth}"><a href="##{e[:id]}">#{e[:label]}</a>#{sub}</li>)
      end
      cls = depth == 1 ? ' class="section-nav"' : ''
      "<ul#{cls}>\n#{items.join("\n")}\n</ul>"
    end
  end
end
