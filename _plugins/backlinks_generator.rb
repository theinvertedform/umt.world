#!/usr/bin/env ruby
# _plugins/backlinks_generator.rb - Generate context-aware backlinks for your Jekyll website
require 'nokogiri'
require 'fileutils'
require 'yaml'
require 'json'

class BacklinksConfig
  attr_reader :site_root, :output_dir, :html_dir, :site_url, :context_chars, :debug

  def initialize(options = {})
    @site_root = options[:site_root] || File.expand_path("~/dev/umtworld") # Changed to your actual site root
    @html_dir = options[:html_dir] || File.join(@site_root, "_site")
    @output_dir = options[:output_dir] || File.join(@site_root, "_data", "backlinks")
    @site_url = options[:site_url] || "https://umt.world"
    @context_chars = options[:context_chars] || 200
    @exclude_paths = options[:exclude_paths] || ["404.html", "feed.xml", "sitemap.xml", "robots.txt", "assets/"]
    @ignored_classes = options[:ignored_classes] || ["backlink-not", "no-backlink"]
    @debug = options[:debug] || false
  end

  def excluded?(path)
    @exclude_paths.any? { |excluded| path.include?(excluded) }
  end

  def ignored_class?(classes)
    return false unless classes
    classes.split.any? { |cls| @ignored_classes.include?(cls) }
  end
end

class Link
  attr_reader :source_path, :source_url, :target_path, :target_url, :link_id, :context, :title

  def initialize(source_path, source_url, target_path, target_url, link_id, context, title)
    @source_path = source_path
    @source_url = source_url
    @target_path = target_path
    @target_url = target_url
    @link_id = link_id
    @context = context
    @title = title
  end

  def to_h
    {
      'source_path' => @source_path,
      'source_url' => @source_url,
      'target_path' => @target_path,
      'target_url' => @target_url,
      'link_id' => @link_id,
      'context' => @context,
      'title' => @title
    }
  end
end

class BacklinksGenerator
  def initialize(options = {})
    @config = BacklinksConfig.new(options)
    @links = []
    @backlinks = {}
    FileUtils.mkdir_p(@config.output_dir)
    FileUtils.mkdir_p(File.join(@config.output_dir, 'snippets'))

    puts "Using HTML directory: #{@config.html_dir}"
    puts "Using output directory: #{@config.output_dir}"
  end

  def extract_links
    puts "Extracting links from HTML files..."

    files_checked = 0
    links_found = 0

    Dir.glob(File.join(@config.html_dir, "**", "*.html")).each do |file|
      rel_path = file.sub(@config.html_dir + '/', '')

      if @config.excluded?(rel_path)
        puts "  Skipping excluded file: #{rel_path}" if @config.debug
        next
      end

      files_checked += 1

      begin
        doc = File.open(file) { |f| Nokogiri::HTML(f) }
        source_url = rel_path.gsub(/index\.html$/, '').gsub(/\.html$/, '')
        source_url = '/' + source_url unless source_url.start_with?('/')

        # Get page title
        title = doc.at_css('title')&.text || source_url
        title = title.sub(' - umt.world', '') # Remove site name from title

        # Debug info
        if @config.debug
          puts "  Checking file: #{rel_path}"
          puts "    Source URL: #{source_url}"
          puts "    Title: #{title}"

          # Check for any links first
          any_links = doc.css('a[href^="/"]').size
          puts "    Found #{any_links} internal links total"

          # Check for links with IDs
          links_with_ids = doc.css('a[id][href^="/"]').size
          puts "    Found #{links_with_ids} internal links with IDs"

          # List actual link_hooks.rb generated IDs for inspection
          puts "    Sample of link IDs found:"
          doc.css('a[id][href^="/"]').each_with_index do |link, index|
            break if index >= 5 # Only show first 5 examples
            puts "      #{link['id']} -> #{link['href']}"
          end
        end

        # Process all links with IDs
        doc.css('a[id][href^="/"]').each do |link|
          if @config.ignored_class?(link['class'])
            puts "    Skipping link with ignored class: #{link['href']}" if @config.debug
            next
          end

          link_id = link['id']
          target_url = link['href']

          # Split the URL into path and fragment
          target_path, fragment = target_url.include?('#') ? target_url.split('#', 2) : [target_url, nil]

          # Extract context - get the parent paragraph or nearest block element
          context_node = find_context_node(link)
          context = extract_context_text(context_node, link, @config.context_chars)

          # Add to links collection
          @links << Link.new(
            rel_path,
            source_url,
            target_path.sub(/\/$/, ''),
            target_url,
            link_id,
            context,
            title
          )

          links_found += 1
          puts "    Added link: #{link_id} (#{target_url})" if @config.debug
        end
      rescue => e
        puts "Error processing #{file}: #{e.message}"
        puts e.backtrace.join("\n") if @config.debug
      end
    end

    puts "Checked #{files_checked} files and found #{links_found} links with IDs"

    # Let's try to diagnose the issue if no links were found
    if links_found == 0
      puts "\nNo links found. Let's diagnose the issue:"

      # Check if any HTML files were found
      html_files = Dir.glob(File.join(@config.html_dir, "**", "*.html")).reject { |f| @config.excluded?(f.sub(@config.html_dir + '/', '')) }
      puts "  Found #{html_files.size} HTML files (excluding filtered ones)"

      if html_files.empty?
        puts "  ❌ No HTML files found. Check if your site is built and the html_dir path is correct."
        puts "  Current html_dir: #{@config.html_dir}"
      else
        # Sample a few files to check if they have any internal links
        sample_file = html_files.first
        puts "  Checking sample file: #{sample_file}"

        begin
          doc = File.open(sample_file) { |f| Nokogiri::HTML(f) }

          # Check for any links
          internal_links = doc.css('a[href^="/"]').size
          puts "    Found #{internal_links} internal links"

          if internal_links > 0
            # There are internal links, but no IDs - check if link_hooks.rb is working
            puts "    ❓ Your HTML has internal links but none have IDs."
            puts "    Check if your link_hooks.rb plugin is working correctly."

            # Show a sample of links without IDs
            puts "    Sample of links without IDs:"
            doc.css('a[href^="/"]').each_with_index do |link, index|
              break if index >= 5
              puts "      #{link['href']} (ID: #{link['id'] || 'none'})"
            end
          else
            puts "    ❌ No internal links found in the sample file."
          end
        rescue => e
          puts "    Error examining sample file: #{e.message}"
        end
      end

      puts "\nPossible solutions:"
      puts "  1. Make sure your site is built before running this script (jekyll build)"
      puts "  2. Check if link_hooks.rb is loaded and working correctly"
      puts "  3. Try modifying the script to match your actual HTML structure"
      puts "  4. Run the script with full debug output: ruby _plugins/backlinks_generator.rb --debug"
    end

    puts "Extracted #{@links.size} links from HTML files."
  end

  def find_context_node(link)
    # Try to find the closest parent that provides good context
    node = link

    # Look for parent paragraph, blockquote, list item, etc.
    context_elements = ['p', 'blockquote', 'li', 'div.markdownBody', 'section', 'article']

    context_elements.each do |selector|
      ancestor = link.ancestors(selector).first
      return ancestor if ancestor
    end

    # If we didn't find a good context element, just use the parent
    return link.parent
  end

  def extract_context_text(node, link, max_chars)
    return '' unless node

    # Get the text content
    text = node.text.strip.gsub(/\s+/, ' ')

    # If the text is short enough, use it all
    return text if text.length <= max_chars

    # Try to find the position of the link text within the context
    link_text = link.text.strip
    link_position = text.index(link_text)

    if link_position
      # Calculate start and end positions for the extract
      half_length = max_chars / 2
      start_pos = [link_position - half_length, 0].max
      end_pos = [link_position + link_text.length + half_length, text.length].min

      # Extract the relevant portion
      extract = text[start_pos...end_pos]

      # Add ellipsis if needed
      extract = "..." + extract if start_pos > 0
      extract = extract + "..." if end_pos < text.length

      return extract
    else
      # If we can't find the link text, just take the first part of the context
      return text[0...max_chars] + "..."
    end
  end

  def organize_backlinks
    puts "Organizing backlinks..."

    # Group links by target URL
    @links.each do |link|
      target_key = link.target_path
      @backlinks[target_key] ||= []
      @backlinks[target_key] << link
    end

    puts "Organized backlinks for #{@backlinks.size} target URLs."
  end

  def generate_backlinks_data
    puts "Generating backlink data files..."

    # Create JSON files for each target
    @backlinks.each do |target_path, links|
      # Create a sanitized filename
      filename = target_path.gsub(/^\//, '').gsub(/\//, '_')
      filename = filename.empty? ? 'index' : filename
      filename = "#{filename}.json"

      # Convert links to hashes
      links_data = links.map(&:to_h)

      # Write to JSON file
      output_path = File.join(@config.output_dir, filename)
      File.write(output_path, JSON.pretty_generate(links_data))
    end

    # Create an index file with all backlinks
    index_path = File.join(@config.output_dir, 'all_backlinks.json')
    all_backlinks = {}

    @backlinks.each do |target_path, links|
      all_backlinks[target_path] = links.map(&:to_h)
    end

    File.write(index_path, JSON.pretty_generate(all_backlinks))

    puts "Generated #{@backlinks.size + 1} backlink data files."
  end

  def generate_html_snippets
    puts "Generating HTML snippets for backlinks..."

    snippets_dir = File.join(@config.output_dir, 'snippets')
    FileUtils.mkdir_p(snippets_dir)

    @backlinks.each do |target_path, links|
      # Create a sanitized filename
      filename = target_path.gsub(/^\//, '').gsub(/\//, '_')
      filename = filename.empty? ? 'index' : filename
      filename = "#{filename}.html"

      # Generate HTML content
      html = generate_backlinks_html(target_path, links)

      # Write to file
      output_path = File.join(snippets_dir, filename)
      File.write(output_path, html)
    end

    puts "Generated #{@backlinks.size} HTML snippet files."
  end

  def generate_backlinks_html(target_path, links)
    # Sort links by source title for easier reading
    links = links.sort_by { |link| link.title.downcase }

    html = <<~HTML
      <div class="backlinks-container">
        <h3>Pages linking to #{target_path}</h3>
        <details>
          <summary>#{links.size} Backlinks</summary>
          <ul class="backlinks-list">
    HTML

    links.each do |link|
      html += <<~HTML
        <li class="backlink-item">
          <a href="#{link.source_url}" class="backlink-source">#{link.title}</a>
          <blockquote class="backlink-context">
            #{link.context}
          </blockquote>
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

  def run
    puts "Starting backlinks generation..."
    extract_links
    organize_backlinks
    generate_backlinks_data
    generate_html_snippets
    puts "Backlinks generation complete!"
  end
end

# Parse command line arguments
if ARGV.include?('--debug')
  debug = true
  ARGV.delete('--debug')
else
  debug = false
end

# If this file is being executed directly, run the generator
if __FILE__ == $PROGRAM_NAME
  generator = BacklinksGenerator.new({debug: debug})
  generator.run
end
