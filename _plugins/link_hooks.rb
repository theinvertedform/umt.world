# _plugins/link_hooks.rb
require 'nokogiri'

module Jekyll
  class LinkHooksGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      @site = site
      @config = site.config.dig('backlinks') || {}
      @excluded_id_elements = @config['excluded_id_elements'] || []

      # Process each document and page
      site.documents.each { |doc| process_item(doc) }
      site.pages.each { |page| process_item(page) }
    end

    def process_item(item)
      # Skip if not HTML
      return unless item.output_ext == ".html"

      begin
        # Parse the document
        doc = Nokogiri::HTML(item.output)

        # Find all internal links and add IDs
        modified = false
        doc.css('a[href^="/"]').each do |link|
          # Skip if link already has an ID
          next if link['id']

          # Skip if the link is in an excluded element
          next if in_excluded_element?(link)

          # Generate an ID based on the link target
          link['id'] = generate_link_id(link['href'])
          modified = true
        end

        # Update the item output if modified
        item.output = doc.to_html if modified
      rescue => e
        Jekyll.logger.error "LinkHooks:", "Error processing #{item.path}: #{e.message}"
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
          link.ancestors.any? { |el| el.name == selector }
        end
      end
    end

    def generate_link_id(url)
      # Remove leading slash and query parameters
      path = url.split('#')[0].split('?')[0]
      path = path[1..-1] if path.start_with?('/')

      # Create a sanitized ID
      id = path.gsub(/[^\w\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-')
      id = "link-#{id}"

      # If there's a fragment, include it
      if url.include?('#')
        fragment = url.split('#')[1]
        fragment = fragment.gsub(/[^\w\s-]/, '').gsub(/\s+/, '-')
        id += "-#{fragment}" unless fragment.empty?
      end

      return id
    end
  end
end
