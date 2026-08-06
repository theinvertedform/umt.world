# _plugins/post_render/dropcaps.rb
#
# Job 4 — wrap section-opening initials in a dropcap span.
#
# Gated on the `dropcaps` frontmatter key, defaulting to `opener`.
#
#   opener   — one cap, on the first body paragraph after .front-matter. With
#              section_divs, prose preceding the first heading is not wrapped
#              in a <section>, so the untitled introduction is a run of bare
#              <p> children of #markdownBody and is what this finds.
#   sections — one cap per top-level section. shift-heading-level-by:1 makes
#              those section.level2. Deliberately never level3: a cap that
#              fires at every sub-heading is over-use, not apparatus.
#   none     — off.
#
# Mints class names only. Runs last in the pass: it is the only job that
# inspects prose rather than structure, and it should see the document the
# reader gets.

require 'cgi'

module PostRender
  module Dropcaps
    MODES = %w[opener sections none].freeze
    DEFAULT_MODE = 'opener'.freeze

    # Sections that are apparatus, not prose. section_divs gives the inserted
    # Bibliography header a level2 section exactly like a real one, so an id
    # denylist is the only discriminator available.
    EXCLUDED_SECTIONS = %w[footnotes bibliography refs backlinks].freeze

    # Block preamble a dropcap steps over to reach the first real paragraph.
    # Gwern's equivalent is the `.epigraph:first-child + p` selector.
    PREAMBLE = %w[blockquote figure aside].freeze
    PREAMBLE_CLASSES = %w[epigraph abstract front-matter].freeze
    PREAMBLE_LIMIT = 3

    # Leading whitespace, optional opening quote/bracket, then the initial.
    # [A-Z0-9] only: the Chandler subset carries U+0030-0039, U+0041-005A and
    # the curly quotes, nothing else. A lowercase opener would fall through to
    # the fallback face, so it is skipped rather than transformed.
    # (Reg. 69: that subset claim is unverified against assets/fonts/.)
    LEAD = /\A(\s*)(["'“”‘’(\[]*)([A-Z0-9])/.freeze

    # Inline apparatus stepped OVER: it renders in the margin or as a
    # reference mark, so the prose still begins at a following sibling.
    INLINE_SKIP = %w[marginnote sidenote footnote-ref].freeze

    # Inline wrappers descended INTO: their content is prose, not apparatus. A
    # dropcap inside a small-caps opening is the Bringhurst arrangement, so
    # the cap is minted in place and the SCSS resets caps/transform on
    # .dropcap. Deliberately excludes em/i/a/strong: Chandler Medium has no
    # italic, and a cap inside an anchor would be part of the link.
    INLINE_DESCEND = %w[smallcaps].freeze

    def self.call(doc, item)
      mode = (item.data['dropcaps'] || DEFAULT_MODE).to_s
      unless MODES.include?(mode)
        Jekyll.logger.warn 'PostRender:', "unknown dropcaps mode '#{mode}' in #{item.path} — skipped"
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

      targets.compact.map { |p| decorate(p, doc) }.any?
    end

    # Top-tier sections only, as direct children — not doc.css, which would
    # also match a nested level2 if one ever appeared.
    def self.top_level_sections(root)
      root.element_children.select { |el| el.name == 'section' && capped_section?(el) }
    end

    def self.capped_section?(el)
      return false unless el.name == 'section'
      return false if EXCLUDED_SECTIONS.include?(el['id'].to_s)
      PostRender.class_list(el).include?('level2')
    end

    def self.opener_paragraph(root)
      root.element_children.each do |el|
        next if PostRender.heading?(el)
        next if skippable_preamble?(el)
        return el if el.name == 'p'
        return section_opener(el) if capped_section?(el)
        return nil
      end
      nil
    end

    # First prose paragraph of a section, stepping over a leading epigraph or
    # figure but refusing to hunt indefinitely.
    #
    # A <p> is only accepted if it actually yields a cappable text node: a
    # marginnote-only paragraph is a <p> whose sole child is a span, and
    # returning it would terminate the walk on a paragraph that can carry no
    # cap. Descends into a leading <section> rather than breaking — a chapter
    # whose first child is an entry section would otherwise yield nothing
    # (ARCHITECTURE Reg. 75).
    def self.section_opener(sec)
      sec.element_children
         .reject { |el| PostRender.heading?(el) }
         .first(PREAMBLE_LIMIT)
         .each do |el|
           if el.name == 'p'
             return el if text_node(el)
             next
           end
           if el.name == 'section'
             found = section_opener(el)
             return found if found
             next
           end
           next if skippable_preamble?(el)
           break
         end
      nil
    end

    def self.skippable_preamble?(el)
      return true if PREAMBLE.include?(el.name)
      (PostRender.class_list(el) & PREAMBLE_CLASSES).any?
    end

    # The opening quotation mark goes inside the span — Bringhurst §4.1.5 —
    # which is why the subset carries U+2018-201D. It also shifts the optical
    # left edge from the letter to the mark, so .dropcap-quoted exists to zero
    # the per-letter overhang in SCSS.
    def self.decorate(p, doc)
      return false if p.at_css('.dropcap')

      tnode = text_node(p)
      return false unless tnode

      m = LEAD.match(tnode.content)
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

    # First text node opening with a cappable initial. Steps over leading
    # margin apparatus, descends into prose-bearing inline wrappers, and
    # refuses everything else — so a paragraph opening in <em> or <a> is
    # skipped rather than given a cap Chandler cannot set or that would join
    # a link.
    def self.text_node(node)
      node.children.each do |n|
        if n.text?
          return n if LEAD.match?(n.content)
          return nil unless n.content.strip.empty?
          next
        end
        return nil unless n.element?
        next if skippable_inline?(n)
        return text_node(n) if descendable_inline?(n)
        return nil
      end
      nil
    end

    def self.skippable_inline?(el)
      return true if el.name == 'sup'
      (PostRender.class_list(el) & INLINE_SKIP).any?
    end

    def self.descendable_inline?(el)
      return false unless el.name == 'span'
      cls = PostRender.class_list(el)
      return true if cls.empty?
      (cls & INLINE_DESCEND).any?
    end
  end
end
