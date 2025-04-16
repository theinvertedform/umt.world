# _plugins/backlinks_generator.rb
require 'nokogiri'
require 'fileutils'
require 'json'

module Jekyll
  class BacklinksGenerator < Jekyll::Generator
    safe true
    priority :lowest # Run after all other generators

    def generate(site)
      # Skip during watch mode/incremental builds
      return if site.config['watch']

      @site = site
      @config = site.config.dig('backlinks') || {}
      @excluded_backlink_pages = @config['excluded_backlink_pages'] || []
      @output_dir = File.join(site.source, @config['output_dir'] || '_data/backlinks')
      @debug = @config['debug'] || false

      # Create output directory
      FileUtils.mkdir_p(@output_dir)
      FileUtils.mkdir_p(File.join(@output_dir, 'snippets'))

      # Extract and organize backlinks
      @all_backlinks = extract_backlinks
      generate_backlink_files
    end

    def extract_backlinks
      backlinks = {}

      @site.documents.each do |doc|
        process_backlinks(doc, backlinks)
      end

      @site.pages.each do |page|
        process_backlinks(page, backlinks)
      end

      return backlinks
    end

    def process_backlinks(item, backlinks)
      # Skip if not HTML
      return unless item.output_ext == ".html"

      # Skip excluded pages for backlink generation
      file_name = File.basename(item.path)
      if @excluded_backlink_pages.include?(file_name)
        Jekyll.logger.debug "Backlinks:", "Skipping backlinks for excluded page: #{file_name}" if @debug
        return
      end

      begin
        # Parse the document
        doc = Nokogiri::HTML(item.output)
        source_url = item.url

        # Get page title
        title = doc.at_css('title')&.text || source_url
        title = title.sub(' - umt.world', '') # Remove site name

        # Find all internal links with IDs
        doc.css('a[href^="/"][id]').each do |link|
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
        end
      rescue => e
        Jekyll.logger.error "Backlinks:", "Error processing #{item.path}: #{e.message}"
      end
    end

    def extract_context(link)
      # Find the containing paragraph or block
      container = find_context_container(link)
      return link.text unless container

      # Get the text
      text = container.text.strip.gsub(/\s+/, ' ')

      # If text is short enough, use all of it
      chars_context = @config.dig('context', 'chars_before').to_i + @config.dig('context', 'chars_after').to_i
      chars_context = 200 if chars_context <= 0

      return text if text.length <= chars_context

      # Find the position of the link text
      link_text = link.text.strip
      link_position = text.index(link_text)

      if link_position
        # Calculate extract positions
        chars_before = @config.dig('context', 'chars_before') || 100
        chars_after = @config.dig('context', 'chars_after') || 100

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
      ['p', 'li', 'blockquote', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'].each do |tag|
        container = link.ancestors(tag).first
        return container if container
      end

      # Fallback to parent
      return link.parent
    end

    def generate_backlink_files
      # Generate JSON data and HTML snippets
      @all_backlinks.each do |target_url, links|
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
      end

      # Write index file
      index_path = File.join(@output_dir, "all_backlinks.json")
      File.write(index_path, JSON.pretty_generate(@all_backlinks))

      Jekyll.logger.info "Backlinks:", "Generated backlinks for #{@all_backlinks.size} pages"
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
end
