require 'digest'

module Jekyll
  class CssDigest < Generator
    priority :highest

    def generate(site)
      files = (
        Dir.glob(File.join(site.source, '_sass', '**', '*.scss')) +
        Dir.glob(File.join(site.source, 'assets', 'css', '**', '*.scss'))
      ).sort
      site.data['css'] = {
        'digest' => Digest::MD5.hexdigest(files.map { |f| File.read(f) }.join)[0, 12]
      }
        Jekyll.logger.info "CacheBust:", "#{files.size} files → #{site.data['css']['digest']}"
    end
  end
end
