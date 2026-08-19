# _plugins/post_render/link_ids.rb
#
# Job 1 — mint link-* ids on internal citing links.
#
# The sole consumer is scripts/generate_backlinks.rb, which scans the built
# _site for [id^="link-"]. These ids are the backlinks subsystem's only input,
# which is why this job runs first and why a failure elsewhere in the pass
# must not take it down with it.

module PostRender
  module LinkIds
    def self.call(doc, item)
      root = doc.at_css('#markdownBody')
      return false unless root

      counts = Hash.new(0)
      modified = false
      root.css('a[href^="/"]').each do |link|
        next if link['id']
        base = generate_link_id(link['href'])
        counts[base] += 1
        link['id'] = counts[base] == 1 ? base : "#{base}-#{counts[base]}"
        modified = true
      end

      modified
    end

    def self.in_excluded_element?(link, selectors)
      selectors.any? do |selector|
        case selector[0]
        when '#'
          id = selector[1..]
          link.ancestors.any? { |el| el['id'] == id }
        when '.'
          cls = selector[1..]
          link.ancestors.any? { |el| PostRender.class_list(el).include?(cls) }
        else
          link.ancestors.any? { |el| el.name == selector }
        end
      end
    end

    # Reg. 68: the '-' join means /books/flights#croft and /books/flights-croft
    # mint the same base id. Latent — it blocks the "(full context)" deep link
    # in §6.1. The fix is a separator the slug rule cannot produce.
    def self.generate_link_id(url)
      path = url.split('#')[0].split('?')[0]
      path = path[1..-1] if path.start_with?('/')

      id = path.gsub('/', '-').gsub(/[^\w\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-')
      id = "link-#{id}"

      if url.include?('#')
        fragment = url.split('#')[1].gsub(/[^\w\s-]/, '').gsub(/\s+/, '-')
        id += "-#{fragment}" unless fragment.empty?
      end

      id
    end
  end
end
