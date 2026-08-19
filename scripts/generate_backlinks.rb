#!/usr/bin/env ruby
# Scans _site for citing links minted by post_render/link_ids.rb and emits
# _data/backlinks/. Pass 2 of the build inlines the result via {% backlinks %}.
#
# The scan needs no exclusion list: the injector is rooted at #markdownBody,
# and #backlinks is a sibling of it, so rendered snippets can never be read
# back as fresh citations. See ARCHITECTURE.md#backlinks.

require 'nokogiri'
require 'fileutils'
require 'json'
require 'yaml'
require 'optparse'
require 'cgi'

class BacklinksGenerator
  # Inline elements kept in a snippet. Everything else is unwrapped to its
  # text: block elements would break the <blockquote>, and unknown markup
  # arrives unbalanced.
  CONTEXT_TAGS = %w[em i strong b cite q code sup sub abbr span mark].freeze
  MAX_WORDS = 250

  def initialize(options = {})
    @site_dir = options[:site_dir] || Dir.pwd
    @html_dir = options[:html_dir] || File.join(@site_dir, '_site')
    @config_file = options[:config_file] || File.join(@site_dir, '_config.yml')
    @debug = options[:debug] || false
    @failures = 0

    load_config

    @output_dir = options[:output_dir] ||
      File.join(@site_dir, @config.dig('backlinks', 'output_dir') || '_data/backlinks')

    puts "Site directory: #{@site_dir}" if @debug
    puts "HTML directory: #{@html_dir}" if @debug
    puts "Output directory: #{@output_dir}" if @debug
  end

  def load_config
    if File.exist?(@config_file)
      @config = YAML.load_file(@config_file) || {}
      puts "Loaded configuration from #{@config_file}" if @debug
    else
      @config = {}
      puts "No configuration file found at #{@config_file}, using defaults" if @debug
    end

    # Two filters sharing one key, distinguished by form: extension-bearing
    # entries filter sources, slash-leading entries filter targets.
    @excluded_backlink_pages = @config.dig('backlinks', 'excluded_backlink_pages') || []
    puts "Excluded pages: #{@excluded_backlink_pages.join(', ')}" if @debug
  end

  def run
    puts "Starting backlinks generation..."

    unless Dir.exist?(@html_dir)
      warn "Error: HTML directory not found at #{@html_dir}"
      warn "Run 'jekyll build' first"
      return false
    end

    backlinks = extract_backlinks

    # Bail before writing. generate_backlink_files clears the output
    # directory, so a partial run would destroy the last good data.
    if @failures > 0
      warn "#{@failures} file(s) failed; output left untouched"
      return false
    end

    generate_backlink_files(backlinks)
    puts "Backlinks generation complete!"
    true
  end

  def extract_backlinks
    puts "Extracting backlinks from HTML files..." if @debug
    backlinks = {}

    html_files = Dir.glob(File.join(@html_dir, "**", "*.html"))
    puts "Found #{html_files.size} HTML files" if @debug

    html_files.each { |file| process_file(file, backlinks) }

    puts "Extracted backlinks for #{backlinks.keys.size} target pages" if @debug
    backlinks
  end

  def process_file(file, backlinks)
    rel_path = file.sub(@html_dir + '/', '')

    if excluded_file?(rel_path)
      puts "Skipping excluded file: #{rel_path}" if @debug
      return
    end

    begin
      doc = File.open(file) { |f| Nokogiri::HTML(f) }

      source_url = rel_path.gsub(/index\.html$/, '').gsub(/\.html$/, '')
      source_url = '/' + source_url unless source_url.start_with?('/')

      # Collapse whitespace BEFORE stripping the suffix: markdownify leaves
      # a newline inside <title>.
      title = (doc.at_css('title')&.text || source_url).gsub(/\s+/, ' ').strip
      title = title.sub(/ [-|] umt\.world\z/, '')

      doc.css('a[href^="/"][id^="link-"]').each do |link|
        target_url = link['href'].split('#')[0].split('?')[0]
        next if target_url =~ /\.(pdf|jpe?g|png|gif|svg|webp|mp3|mp4|zip)$/i
        next if @excluded_backlink_pages.include?(target_url)
        next if target_url == source_url

        backlinks[target_url] ||= []
        backlinks[target_url] << {
          'source_url' => source_url,
          'target_url' => target_url,
          'link_id'    => link['id'],
          'context'    => extract_context(link),
          'title'      => title
        }

        puts "  Added backlink: #{source_url} -> #{target_url}" if @debug
      end
    rescue => e
      @failures += 1
      warn "Error processing file #{file}: #{e.message}"
      warn e.backtrace.join("\n") if @debug
    end
  end

  def excluded_file?(path)
    @excluded_backlink_pages.any? do |excluded|
      if excluded.end_with?('/')
        path.start_with?(excluded)
      else
        path == excluded || path.end_with?("/#{excluded}")
      end
    end
  end

  # Returns an HTML fragment safe to interpolate: inline formatting kept,
  # all attributes dropped, footnote refs and sidenotes removed, the citing
  # link renamed to <mark>. Over MAX_WORDS it degrades to escaped plain
  # text — truncating a tree at a word boundary cannot be done on a string,
  # and an unbalanced fragment is the one input Nokogiri does not survive.
  def extract_context(link)
    container = find_context_container(link)
    return CGI.escapeHTML(link.text.strip) unless container
    return truncated_text(container.text) if container.text.split.size > MAX_WORDS

    frag = Nokogiri::HTML.fragment(container.inner_html)
    frag.css('a.footnote-ref, .sidenote, .marginnote').remove
    frag.css("a##{link['id']}").each { |a| a.name = 'mark' }
    sanitize!(frag)
    frag.to_html.gsub(/\s+/, ' ').strip
  end

  # css('*') is document order, parents first, so unwrapping a parent leaves
  # its children in the tree for their own iteration. <a> is deliberately
  # absent from CONTEXT_TAGS: no link inside a link.
  def sanitize!(frag)
    frag.css('*').each do |el|
      if CONTEXT_TAGS.include?(el.name)
        el.attribute_nodes.each { |a| el.remove_attribute(a.name) }
      else
        el.replace(el.children)
      end
    end
  end

  def truncated_text(text)
    words = text.split
    t = words.first(MAX_WORDS).join(' ')
    cut = t.rindex(/[.!?]\s/)
    t = t[0..cut + 1] if cut && cut > t.length / 2
    CGI.escapeHTML(t.strip) + '…'
  end

  def find_context_container(link)
    %w[p li blockquote h1 h2 h3 h4 h5 h6 div section].each do |tag|
      container = link.ancestors(tag).first
      return container if container
    end
    link.parent
  end

  def generate_backlink_files(backlinks)
    puts "Generating backlink files..."

    # The directory is cleared so a target that stops being cited does not
    # keep its file forever. Guarded because the path is config-derived.
    unless File.basename(@output_dir) == 'backlinks'
      warn "Refusing to clear #{@output_dir}: expected a directory named 'backlinks'"
      return false
    end
    FileUtils.rm_rf(@output_dir)
    FileUtils.mkdir_p(File.join(@output_dir, 'snippets'))

    backlinks.each do |target_url, links|
      next if links.empty?

      filename = target_url.gsub(/^\//, '').gsub(/\//, '_')
      filename = "index" if filename.empty?

      File.write(File.join(@output_dir, "#{filename}.json"),
                 JSON.pretty_generate(links))
      File.write(File.join(@output_dir, 'snippets', "#{filename}.html"),
                 generate_html_snippet(links))

      puts "  Generated backlinks file for #{target_url}" if @debug
    end

    File.write(File.join(@output_dir, "all_backlinks.json"),
               JSON.pretty_generate(backlinks))

    puts "Generated backlinks for #{backlinks.size} pages"
    true
  end

  # 'context' is interpolated unescaped: extract_context guarantees it is
  # either sanitized HTML or already-escaped text. Everything else escapes.
  def generate_html_snippet(links)
    links.sort_by! { |link| link['title'].downcase }

    html = <<~HTML
      <div class="backlinks-container">
        <h2>Backlinks</h2>
        <details>
          <summary>#{links.size} page#{links.size == 1 ? '' : 's'} link#{links.size == 1 ? 's' : ''} to this page</summary>
          <ul class="backlinks-list">
    HTML

    links.each do |link|
      html += <<~HTML
            <li class="backlink-item">
              <a href="#{CGI.escapeHTML(link['source_url'])}" class="backlink-source">#{CGI.escapeHTML(link['title'])}</a>
              <blockquote class="backlink-context">#{link['context']}</blockquote>
            </li>
      HTML
    end

    html + <<~HTML
          </ul>
        </details>
      </div>
    HTML
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby generate_backlinks.rb [options]"
  opts.on("-s", "--site-dir DIR",   "Site directory (default: cwd)")        { |d| options[:site_dir] = d }
  opts.on("-b", "--html-dir DIR",   "Built HTML directory (default: _site)") { |d| options[:html_dir] = d }
  opts.on("-c", "--config FILE",    "Config file (default: _config.yml)")    { |f| options[:config_file] = f }
  opts.on("-o", "--output-dir DIR", "Output directory")                      { |d| options[:output_dir] = d }
  opts.on("-d", "--debug",          "Enable debug output")                   { options[:debug] = true }
  opts.on("-h", "--help")                                                    { puts opts; exit }
end.parse!

exit(BacklinksGenerator.new(options).run ? 0 : 1)
