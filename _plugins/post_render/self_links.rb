# _plugins/post_render/self_links.rb
#
# Job 3a — wrap each section heading's contents in a.anchor pointing at the
# section's own id.
#
# This has no relation to the TOC and is deliberately uncapped: a page that
# hides its subsections from the TOC (toc_max_level) still wants every heading
# addressable. That is why this is a separate walk from Toc's rather than a
# side effect of building the entry tree.
#
# The href comes from the id pandoc put on the enclosing section. Nothing here
# mints an id.

require 'nokogiri'

module PostRender
  module SelfLinks
    ANCHOR_CLASS = 'anchor'.freeze

    def self.call(doc, item)
      root = doc.at_css('#markdownBody')
      return false unless root

      walk(root, doc, {})
    end

    # Pandoc nests <section> by heading level, so the DOM is already the tree.
    # Returns true if any anchor was added.
    def self.walk(node, doc, seen)
      modified = false

      node.element_children.each do |el|
        next unless el.name == 'section'

        id = el['id']
        next if id.nil? || id.empty?

        heading = el.element_children.find { |e| PostRender.heading?(e) }
        next unless heading
        next if heading.text.strip.empty?

        # A duplicate id means a self-link on the second occurrence would
        # resolve to the first. Skipped silently — Toc emits the warning, and
        # emitting it from both jobs would double every line.
        next if seen[id]
        seen[id] = true

        modified |= add(heading, id, doc)
        modified |= walk(el, doc, seen)
      end

      modified
    end

    def self.add(heading, id, doc)
      return false if heading.element_children.any? { |e|
        e.name == 'a' && PostRender.class_list(e).include?(ANCHOR_CLASS)
      }

      a = Nokogiri::XML::Node.new('a', doc)
      a['class'] = ANCHOR_CLASS
      a['href'] = "##{id}"
      heading.children.to_a.each { |c| a.add_child(c) }
      heading.add_child(a)

      true
    end
  end
end
