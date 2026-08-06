# _plugins/post_render/shared.rb
#
# Constants and predicates used by more than one job. Nothing here touches the
# document — anything that does belongs to a job.

module PostRender
  HEADINGS = %w[h1 h2 h3 h4 h5 h6].freeze
  HEADING_SELECTOR = HEADINGS.join(',').freeze

  def self.heading?(el)
    HEADINGS.include?(el.name)
  end

  def self.class_list(el)
    el['class'].to_s.split
  end
end
