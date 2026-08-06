# _plugins/post_render/footnotes.rb
#
# Job 2 — title the footnotes section.
#
# pandoc's HTML writer emits <section id="footnotes"> with no heading, at
# serialization time. No AST node exists for it, so no Lua filter can reach
# it. This is the only stage at which it can be titled.
#
# MUST run before Toc: the TOC walk skips a section that has an id but no
# heading, so without this the footnotes never appear in the TOC.

require 'nokogiri'

module PostRender
  module Footnotes
    HEADING_LEVEL = 'h2'.freeze
    LABEL = 'Footnotes'.freeze

    # Reg. 67: at_css is singular, so on a page assembled from several
    # documents only the FIRST section#footnotes is titled — wrong on
    # podcast.html. Behaviour preserved verbatim here so the split can be
    # verified by diffing _site. Changing `fn =` to `root.css(...)` and
    # mapping `insert` over it is the whole fix, once that diff is clean.
    def self.call(doc, item)
      root = doc.at_css('#markdownBody')
      return false unless root

      fn = root.at_css('> section#footnotes') || root.at_css('section#footnotes')
      return false unless fn

      insert(fn, doc)
    end

    def self.insert(fn, doc)
      return false if fn.element_children.any? { |e| PostRender.heading?(e) }

      h = Nokogiri::XML::Node.new(HEADING_LEVEL, doc)
      h.content = LABEL

      # After the rule pandoc emits, if there is one; otherwise first child.
      hr = fn.at_css('> hr')
      if hr
        hr.add_next_sibling(h)
      elsif fn.children.first
        fn.children.first.add_previous_sibling(h)
      else
        fn.add_child(h)
      end

      true
    end
  end
end
