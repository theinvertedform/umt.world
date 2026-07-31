# _plugins/concat_collection.rb
#
#     {% concat_collection diaries %}
#
# Returns the *source markdown* of every document in a collection, frontmatter
# stripped, sorted by the `date` field, joined. Liquid runs before the
# converter, so the result is converted as part of the host page: one pandoc
# document, one #refs, one #footnotes, one fn1 sequence.
#
# This exists because the alternative — a Liquid loop over `{{ item.content }}`
# — injects already-converted HTML into the host page, where it arrives as a
# RawBlock. Pandoc cannot see headings inside raw HTML, so section_divs never
# finds a terminator for the host document's own level-2 sections and the
# Bibliography section swallows every item after it. See ARCHITECTURE §4.2.
#
# Source is read from DISK, not from site.<collection>. A Document's `content`
# holds raw markdown only until that document renders, and render order
# relative to pages is not guaranteed.
#
# The returned string is NOT re-parsed as Liquid. Corpus prose containing {{ or
# {% passes through untouched — which is the desired behaviour — but any Liquid
# authored in a collection document is inert.
#
# Place the tag at column zero. Liquid preserves the indentation of the line the
# tag sits on, and an indented first line makes pandoc read the whole
# concatenation as a code block.

require 'yaml'

module Jekyll
  class ConcatCollectionTag < Liquid::Tag
    FRONTMATTER = /\A---\s*\r?\n(.*?)\r?\n---\s*\r?\n?(.*)\z/m.freeze

    # Date and Time appear in frontmatter as native YAML scalars; Psych 4+
    # refuses to instantiate them unless permitted.
    YAML_CLASSES = [Date, Time].freeze

    def initialize(tag_name, markup, tokens)
      super
      @label = markup.strip.sub(/\A_/, '')
      raise ArgumentError, 'concat_collection: expected a collection label' if @label.empty?
    end

    def render(context)
      site = context.registers[:site]
      dir = collection_dir(site)

      paths = Dir.glob(File.join(dir, '*.md')).sort
      if paths.empty?
        Jekyll.logger.warn 'ConcatCollection:', "no documents found in #{dir}"
        return ''
      end

      register_dependencies(site, context, paths)

      bodies = paths.map { |path|
        data, body = split_frontmatter(File.read(path, encoding: 'utf-8'))
        [sort_key(data, path), File.basename(path), body.strip]
      }.sort_by { |key, name, _| [key, name] }
       .map { |_, _, body| body }
       .reject(&:empty?)

      Jekyll.logger.debug 'ConcatCollection:', "#{@label}: #{bodies.length} documents"

      # Leading and trailing newlines guarantee the concatenation starts and
      # ends on block boundaries regardless of what surrounds the tag.
      "\n#{bodies.join("\n\n")}\n"
    end

    private

    def collection_dir(site)
      site.in_source_dir(site.config['collections_dir'].to_s, "_#{@label}")
    end

    def split_frontmatter(raw)
      m = FRONTMATTER.match(raw)
      return [{}, raw] unless m

      data =
        begin
          YAML.safe_load(m[1], permitted_classes: YAML_CLASSES) || {}
        rescue StandardError => e
          Jekyll.logger.warn 'ConcatCollection:', "unparseable frontmatter: #{e.message}"
          {}
        end

      [data, m[2]]
    end

    # Lexical comparison on YYYY-MM-DD is chronological, so no Date round-trip
    # is needed. A document with no usable date sorts by filename, after every
    # dated one.
    def sort_key(data, path)
      value = data['date']
      case value
      when Date, Time, DateTime then value.to_s[0, 10]
      when String               then value.strip[0, 10]
      else
        Jekyll.logger.warn 'ConcatCollection:', "no date in #{File.basename(path)} — sorting last"
        '9999-99-99'
      end
    end

    # Without this, editing a chapter file under `jekyll serve` regenerates
    # nothing: the watcher has no idea the host page reads it.
    def register_dependencies(site, context, paths)
      page = context.registers[:page]
      return unless page.is_a?(Hash) && page['path']
      return unless site.respond_to?(:regenerator)

      source = site.in_source_dir(page['path'])
      paths.each { |path| site.regenerator.add_dependency(source, path) }
    rescue StandardError => e
      Jekyll.logger.debug 'ConcatCollection:', "dependency registration failed: #{e.message}"
    end
  end
end

Liquid::Template.register_tag('concat_collection', Jekyll::ConcatCollectionTag)

