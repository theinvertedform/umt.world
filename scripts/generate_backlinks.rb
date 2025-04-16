#!/usr/bin/env ruby
# ~/.local/share/bin/generate_backlinks.rb
# A standalone script to generate backlinks for a Jekyll site

require 'nokogiri'
require 'fileutils'
require 'json'
require 'yaml'
require 'optparse'

class BacklinksGenerator
  def initialize(options = {})
    @site_dir = options[:site_dir] || Dir.pwd
    @html_dir = options[:html_dir] || File.join(@site_dir, '_site')
    @config_file = options[:config_file] || File.join(@site_dir, '_config.yml')
    @debug = options[:debug] || false

    # Load configuration
    load_config

    # Set up directories
    @output_dir = options[:output_dir] || File.join(@site_dir, @config.dig('backlinks', 'output_dir') || '_data/backlinks')
    FileUtils.mkdir_p(@output_dir)
    FileUtils.mkdir_p(File.join(@output_dir, 'snippets'))

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

    # Set up excluded pages
    @excluded_backlink_pages = @config.dig('backlinks', 'excluded_backlink_pages') || [
      "404.html", "feed.xml", "sitemap.xml", "robots.txt"
    ]

    # Elements to skip (sidebar links, etc.)
    @excluded_id_elements = @config.dig('backlinks', 'excluded_id_elements') || [
      "#sidebar", ".sidebar-links"
    ]

    puts "Excluded pages: #{@excluded_backlink_pages.join(', ')}" if @debug
    puts "Excluded elements: #{@excluded_id_elements.join(', ')}" if @debug
  end

  def run
    puts "Starting backlinks generation..."

    # First, check if the HTML directory exists
    unless Dir.exist?(@html_dir)
      puts "Error: HTML directory not found at #{@html_dir}"
      puts "Please run 'jekyll build' first to generate the site"
      return false
    end

    # Process the site and extract backlinks
    backlinks = extract_backlinks

    # Generate backlink files
    generate_backlink_files(backlinks)

    puts "Backlinks generation complete!"
    return true
  end

  def extract_backlinks
    puts "Extracting backlinks from HTML files..." if @debug
    backlinks = {}

    # Find all HTML files
    html_files = Dir.glob(File.join(@html_dir, "**", "*.html"))
    puts "Found #{html_files.size} HTML files" if @debug

    html_files.each do |file|
      process_file(file, backlinks)
    end

    puts "Extracted backlinks for #{backlinks.keys.size} target pages" if @debug
    return backlinks
  end

  def process_file(file, backlinks)
    # Get relative path from HTML directory
    rel_path = file.sub(@html_dir + '/', '')

    # Skip excluded files
    if excluded_file?(rel_path)
      puts "Skipping excluded file: #{rel_path}" if @debug
      return
    end

    begin
      # Parse the document
      doc = File.open(file) { |f| Nokogiri::HTML(f) }

      # Get URL (remove index.html and .html extension)
      source_url = rel_path.gsub(/index\.html$/, '').gsub(/\.html$/, '')
      source_url = '/' + source_url unless source_url.start_with?('/')

      # Get page title
      title = doc.at_css('title')&.text || source_url
      title = title.sub(' - umt.world', '') # Remove site name

      # Find all internal links with IDs
      doc.css('a[href^="/"][id]').each do |link|
        # Skip if link is in an excluded element
        next if in_excluded_element?(link)

        # Get target URL (remove fragments and query params)
        target_url = link['href'].split('#')[0].split('?')[0]

        # Extract context
        context = extract_context(link)

        # Add to backlinks collection
        backlinks[target_url] ||= []
        backlinks[target_url] << {
          'source_url' => source_url,
          'target_url' => target_url,
          'link_id' => link['id'],
          'context' => context,
          'title' => title
        }

        puts "  Added backlink: #{source_url} -> #{target_url}" if @debug
      end
    rescue => e
      puts "Error processing file #{file}: #{e.message}"
      puts e.backtrace.join("\n") if @debug
    end
  end

  def excluded_file?(path)
    @excluded_backlink_pages.any? do |excluded|
      # Use exact match for specific files, substring match for directories
      if excluded.end_with?('/')
        path.start_with?(excluded)
      else
        path == excluded || path.end_with?("/#{excluded}")
      end
    end
  end

  def in_excluded_element?(link)
    @excluded_id_elements.any? do |selector|
      if selector.start_with?('#')
        # ID selector
        id = selector[1..]
        link.ancestors.any? { |el| el['id'] == id }
      elsif selector.start_with?('.')
        # Class selector
        cls = selector[1..]
        link.ancestors.any? do |el|
          el['class'] && el['class'].split.include?(cls)
        end
      else
        # Element selector
        link.ancestors.any? { |el| el.name.downcase == selector.downcase }
      end
    end
  end

  def extract_context(link)
    # Find the containing paragraph or block
    container = find_context_container(link)
    return link.text unless container

    # Get the text
    text = container.text.strip.gsub(/\s+/, ' ')

    # If text is short enough, use all of it
    chars_before = @config.dig('backlinks', 'context', 'chars_before') || 100
    chars_after = @config.dig('backlinks', 'context', 'chars_after') || 100
    chars_context = chars_before + chars_after

    return text if text.length <= chars_context

    # Find the position of the link text
    link_text = link.text.strip
    link_position = text.index(link_text)

    if link_position
      # Calculate extract positions
      start_pos = [link_position - chars_before, 0].max
      end_pos = [link_position + link_text.length + chars_after, text.length].min

      # Extract text with ellipses if needed
      extract = text[start_pos...end_pos]
      extract = "..." + extract if start_pos > 0
      extract = extract + "..." if end_pos < text.length

      return extract
    else
      # Fallback if link text not found
      return text[0...chars_context] + "..."
    end
  end

  def find_context_container(link)
    # Look for appropriate container elements
    ['p', 'li', 'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'div', 'section'].each do |tag|
      container = link.ancestors(tag).first
      return container if container
    end

    # Fallback to parent
    return link.parent
  end

  def generate_backlink_files(backlinks)
    puts "Generating backlink files..."

    # Generate JSON data and HTML snippets
    backlinks.each do |target_url, links|
      # Skip if no backlinks
      next if links.empty?

      # Create filename
      filename = target_url.gsub(/^\//, '').gsub(/\//, '_')
      filename = "index" if filename.empty?

      # Write JSON data
      json_path = File.join(@output_dir, "#{filename}.json")
      File.write(json_path, JSON.pretty_generate(links))

      # Write HTML snippet
      snippet_path = File.join(@output_dir, 'snippets', "#{filename}.html")
      File.write(snippet_path, generate_html_snippet(links))

      puts "  Generated backlinks file for #{target_url}" if @debug
    end

    # Write index file
    index_path = File.join(@output_dir, "all_backlinks.json")
    File.write(index_path, JSON.pretty_generate(backlinks))

    puts "Generated backlinks for #{backlinks.size} pages"
  end

  def generate_html_snippet(links)
    # Sort links by title
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
              <a href="#{link['source_url']}" class="backlink-source">#{link['title']}</a>
              <blockquote class="backlink-context">#{link['context']}</blockquote>
            </li>
      HTML
    end

    html += <<~HTML
          </ul>
        </details>
      </div>
    HTML

    return html
  end
end

# Parse command line options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby generate_backlinks.rb [options]"

  opts.on("-s", "--site-dir DIR", "Site directory (default: current directory)") do |dir|
    options[:site_dir] = dir
  end

  opts.on("-b", "--html-dir DIR", "Built HTML directory (default: _site)") do |dir|
    options[:html_dir] = dir
  end

  opts.on("-c", "--config FILE", "Config file (default: _config.yml)") do |file|
    options[:config_file] = file
  end

  opts.on("-o", "--output-dir DIR", "Output directory (default: _data/backlinks)") do |dir|
    options[:output_dir] = dir
  end

  opts.on("-d", "--debug", "Enable debug output") do
    options[:debug] = true
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end.parse!

# Run the generator
generator = BacklinksGenerator.new(options)
generator.run
