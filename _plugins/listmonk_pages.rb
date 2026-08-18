module Jekyll
  # Mints listmonk's public Go templates from the site's own layout and
  # includes, so chrome has one authority. Output ext is .tpl so the
  # post-render pass and jekyll-sitemap both skip these pages.
  class ListmonkGenerator < Generator
    safe true
    priority :low

    def generate(site)
      page = PageWithoutAFile.new(site, site.source, 'listmonk', 'index.tpl')
      page.data.merge!(
        'layout'      => 'listmonk',
        'title'       => '{{ .Data.Title }}',
        'description' => '{{ .Data.Description }}',
        'toc'         => false,
        'dropcaps'    => 'none',
        'minimal'     => true,
      )
      page.content = ''
      site.pages << page
    end
  end
end
