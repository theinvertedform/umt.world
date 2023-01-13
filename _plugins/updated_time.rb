module Jekyll
  class UpdatedTime < Generator
    def generate(site)
      site.posts.docs.each do |post|
        post.data['updated'] = File.mtime(post.path)
      end
    end
  end
end
