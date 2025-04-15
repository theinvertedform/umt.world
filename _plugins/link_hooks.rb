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

  begin
    # Use Nokogiri to parse and modify HTML
    doc = Nokogiri::HTML(item.output)

    # Find all internal links
    doc.css('a[href^="/"]').each do |link|
      # Skip if link already has an ID
      next if link['id']

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
