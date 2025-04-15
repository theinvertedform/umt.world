# _plugins/backlinks_include.rb
# This plugin provides a Liquid tag to include backlinks in your pages

module Jekyll
  class BacklinksIncludeTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
      super
      @params = params.strip
    end

    def render(context)
      site = context.registers[:site]
      page_path = context['page']['url'].gsub(/\/$/, '')

      # Default to current page if no path specified
      if @params.empty?
        path = page_path
      else
        path = @params
      end

      # Create filename for the backlinks snippet
      filename = path.gsub(/^\//, '').gsub(/\//, '_')
      filename = filename.empty? ? 'index' : filename
      snippet_path = File.join(site.source, '_data', 'backlinks', 'snippets', "#{filename}.html")

      # Check if the backlinks snippet exists
      if File.exist?(snippet_path)
        content = File.read(snippet_path)
        return content
      else
        return "<div class='no-backlinks'>No backlinks found</div>"
      end
    end
  end
end

Liquid::Template.register_tag('backlinks', Jekyll::BacklinksIncludeTag)
