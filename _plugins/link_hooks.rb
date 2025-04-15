# _plugins/link_hooks.rb
require 'nokogiri'

module LinkIdHelpers
  def self.generate_link_id(url)
    # Split the URL into path and fragment
    path, fragment = url.include?('#') ? url.split('#', 2) : [url, nil]

    # Sanitize path (remove leading slash, replace special chars)
    path = path[1..-1] if path.start_with?('/')
    path = self.sanitize_for_id(path)

    # Create ID components
    site_prefix = "umt"  # Your site prefix

    if fragment && !fragment.empty?
      # For links with fragments
      fragment = self.sanitize_for_id(fragment)
      return "#{site_prefix}-#{path}--#{fragment}"
    else
      # For links without fragments
      return "#{site_prefix}-#{path}"
    end
  end

  def self.sanitize_for_id(text)
    # Remove special characters and replace with hyphens
    text = text.to_s
             .gsub(/[^\w\s-]/, '')  # Remove non-word/space/hyphen chars
             .gsub(/\s+/, '-')      # Replace spaces with hyphens
             .gsub(/-+/, '-')       # Replace multiple hyphens with single
             .gsub(/^-+|-+$/, '')   # Remove leading/trailing hyphens
    return text
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |item|
  # Skip if not HTML
  next unless item.output_ext == ".html"

  # Get the excluded pages and elements from config
  site_config = item.site.config
  excluded_pages = site_config.dig('backlinks', 'excluded_pages') || []
  excluded_elements = site_config.dig('backlinks', 'excluded_elements') || []

  # Skip processing if the page is in the excluded list
  file_name = File.basename(item.path)
  if excluded_pages.include?(file_name)
    Jekyll.logger.debug "LinkHooks:", "Skipping excluded page: #{item.path}"
    next
  end

  if excluded_pages.include?(file_name)
    Jekyll.logger.debug "LinkHooks:", "Excluding page: #{item.path} (filename: #{file_name})"
    next
  end

  begin
    # Use Nokogiri to parse and modify HTML
    doc = Nokogiri::HTML(item.output)

    # Find all internal links
    doc.css('a[href^="/"]').each do |link|
      # Skip if link already has an ID
      next if link['id']

      # Skip if the link is in an excluded element
      skip_link = false
      excluded_elements.each do |excluded|
        if excluded.start_with?('#')
          # ID selector
          element_id = excluded[1..]
          element = doc.at_css("##{element_id}")
          if element && element.css('a').include?(link)
            skip_link = true
            break
          end
        elsif excluded.start_with?('.')
          # Class selector
          class_name = excluded[1..]
          elements = doc.css(".#{class_name}")
          if elements.any? { |el| el.css('a').include?(link) }
            skip_link = true
            break
          end
        else
          # Element selector
          elements = doc.css(excluded)
          if elements.any? { |el| el.css('a').include?(link) }
            skip_link = true
            break
          end
        end
      end
      next if skip_link

      # Generate an ID based on the link target
      href = link['href']
      link['id'] = LinkIdHelpers.generate_link_id(href)
    end

    # Save the modified HTML back to the page
    item.output = doc.to_html
  rescue => e
    # Log any errors but don't crash the build
    Jekyll.logger.error "LinkHooks:", "Error processing #{item.path}: #{e.message}"
  end
end
