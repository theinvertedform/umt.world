# _plugins/link_hooks.rb
require 'nokogiri'

module LinkHooks
  def self.process(item)
    return unless item.output_ext == ".html"
    return if item.output.nil? || item.output.empty?

    excluded = (item.site.config.dig('backlinks', 'excluded_id_elements') || [])
    doc = Nokogiri::HTML(item.output)
    counts = Hash.new(0)
    modified = false

    doc.css('a[href^="/"]').each do |link|
      next if link['id']
      next if in_excluded_element?(link, excluded)

      base = generate_link_id(link['href'])
      counts[base] += 1
      link['id'] = counts[base] == 1 ? base : "#{base}-#{counts[base]}"
      modified = true
    end

    item.output = doc.to_html if modified
  rescue => e
    Jekyll.logger.error "LinkHooks:", "Error processing #{item.path}: #{e.message}"
  end

  def self.in_excluded_element?(link, selectors)
    selectors.any? do |selector|
      if selector.start_with?('#')
        id = selector[1..]
        link.ancestors.any? { |el| el['id'] == id }
      elsif selector.start_with?('.')
        cls = selector[1..]
        link.ancestors.any? do |el|
          el['class'] && el['class'].split.include?(cls)
        end
      else
        link.ancestors.any? { |el| el.name == selector }
      end
    end
  end

  def self.generate_link_id(url)
    path = url.split('#')[0].split('?')[0]
    path = path[1..-1] if path.start_with?('/')

    id = path.gsub('/', '-').gsub(/[^\w\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-')
    id = "link-#{id}"

    if url.include?('#')
      fragment = url.split('#')[1]
      fragment = fragment.gsub(/[^\w\s-]/, '').gsub(/\s+/, '-')
      id += "-#{fragment}" unless fragment.empty?
    end

    id
  end
end

Jekyll::Hooks.register [:documents, :pages], :post_render do |item|
  LinkHooks.process(item)
end
