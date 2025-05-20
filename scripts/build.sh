#!/bin/bash
set -e

# Install nokogiri dependencies
echo "Installing nokogiri dependencies..."
apt-get update && apt-get install -y build-essential libxml2-dev libxslt-dev

# Install required gems
echo "Installing gems..."
bundle install

# Build the site
echo "Building Jekyll site..."
JEKYLL_ENV=production bundle exec jekyll build

# Generate backlinks (only if the script exists)
if [ -f "scripts/generate_backlinks.rb" ]; then
  echo "Generating backlinks..."
  ruby scripts/generate_backlinks.rb --site-dir . --html-dir _site --output-dir _data/backlinks

  # Rebuild the site to include the backlinks data
  echo "Rebuilding Jekyll site with backlinks..."
  JEKYLL_ENV=production bundle exec jekyll build
else
  echo "Skipping backlinks generation (script not found)"
fi

echo "Build completed successfully!"
