#!/bin/bash
set -e

# Install required gems
echo "Installing gems..."
bundle install

# Build the site
echo "Building Jekyll site..."
JEKYLL_ENV=production bundle exec jekyll build

# Generate backlinks (only if the script exists and works)
if [ -f "scripts/generate_backlinks.rb" ]; then
  echo "Attempting to generate backlinks..."
  if ruby scripts/generate_backlinks.rb --site-dir . --html-dir _site --output-dir _data/backlinks; then
    echo "Backlinks generated successfully"

    # Rebuild the site to include the backlinks data
    echo "Rebuilding Jekyll site with backlinks..."
    JEKYLL_ENV=production bundle exec jekyll build
  else
    echo "Backlinks generation failed, but continuing with build"
    # We don't want to fail the entire build just because backlinks generation failed
  fi
else
  echo "Skipping backlinks generation (script not found)"
fi

echo "Build completed successfully!"
