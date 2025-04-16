# _plugins/backlinks_include.rb
module Jekyll
  class BacklinksIncludeTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
      super
      @params = params.strip
    end

    def render(context)
      site = context.registers[:site]
      page = context['page']

      # Get the current page path or specified path
      if @params.empty?
        path = page['url']
      else
        path = @params
      end

      # Normalize path
      path = path.split('#')[0].split('?')[0]

      # Create snippet filename
      filename = path.gsub(/^\//, '').gsub(/\//, '_')
      filename = "index" if filename.empty?

      # Check if snippet exists
      snippet_path = File.join(site.source, site.config.dig('backlinks', 'output_dir') || '_data/backlinks', 'snippets', "#{filename}.html")

      if File.exist?(snippet_path)
        content = File.read(snippet_path)
        return content
      else
        return ""
      end
    end
  end
end

Liquid::Template.register_tag('backlinks', Jekyll::BacklinksIncludeTag)
