source "https://rubygems.org"

gem "jekyll", "~> 4.2.2"
#gem "minima", "~> 2.5"
# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins
# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
  gem "jekyll-toc"
  gem 'jekyll-redirect-from'
  gem 'jekyll-last-modified-at'
  gem "jekyll-pandoc"
  gem "jekyll-github-metadata"
  gem 'jekyll-sass-converter'
  gem 'csv'
  gem 'base64'
  gem 'bigdecimal'
  gem 'nokogiri'
end

platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]

gem "webrick", "~> 1.8"

gem "rake", "~> 13.2"
