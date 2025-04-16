#!/bin/bash
set -e

# Install required gems
echo "Installing gems..."
bundle install

# Build the site
echo "Building Jekyll site..."
JEKYLL_ENV=production bundle exec jekyll build

# Generate backlinks
echo "Generating backlinks..."
ruby scripts/generate_backlinks.rb --site-dir . --html-dir _site --output-dir _data/backlinks

# Rebuild the site to include the backlinks data
echo "Rebuilding Jekyll site with backlinks..."
JEKYLL_ENV=production bundle exec jekyll build

echo "Build completed successfully!"
