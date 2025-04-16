# Rakefile
require 'jekyll'

desc 'Generate backlinks'
task :backlinks, [:debug] do |t, args|
  debug = args.debug == 'true'
  puts "Generating backlinks (debug: #{debug})"

  # Initialize Jekyll site
  config_file = '_config.yml'
  config = Jekyll::Configuration.from_file(config_file)
  site = Jekyll::Site.new(config)
  site.reset
  site.read
  site.generate

  # Load the backlinks generator
  require_relative '_plugins/backlinks_generator'

  # Create and run processor
  processor = BacklinksProcessor.new(site, debug: debug)
  processor.process
end

desc 'Full build with backlinks'
task :build do
  # First build to generate HTML files
  sh 'bundle exec jekyll build'

  # Generate backlinks
  Rake::Task['backlinks'].invoke

  # Second build to incorporate backlinks
  sh 'bundle exec jekyll build'

  puts "Build complete with backlinks"
end
