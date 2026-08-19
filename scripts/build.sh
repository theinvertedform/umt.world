#!/bin/bash
set -e

./scripts/check.sh env

# Install required gems
echo "Installing gems..."
[[ -n "${CI:-}" ]] || bundle install

# Build the site
echo "Building Jekyll site..."
JEKYLL_ENV=production bundle exec jekyll build

# Generate backlinks (only if the script exists and works)
if [ -f "scripts/generate_backlinks.rb" ]; then
  echo "Attempting to generate backlinks..."
  if bundle exec ruby scripts/generate_backlinks.rb --site-dir . --html-dir _site --output-dir _data/backlinks; then
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

./scripts/check.sh site

# --- newsletter artifacts ----------------------------------------------
# _site/listmonk/index.tpl is listmonk's Go chrome, rendered from the
# site's own layout and includes. It is build output for a different
# host and must never reach S3.

NEWS_DIR="${NEWS_DIR:-/var/www/news.umt.local}"
TPL="_site/listmonk/index.tpl"

if [ -f "$TPL" ] && [ -d "$NEWS_DIR/.git" ]; then
  echo "Placing newsletter artifacts in $NEWS_DIR"

  grep -q localhost "$TPL" && { echo "artifact contains localhost — stop jekyll serve" >&2; exit 1; }

  install -m 644 _site/news.html "$NEWS_DIR/signup.html"
  install -m 644 "$TPL" "$NEWS_DIR/static/public/templates/index.html"
  install -m 644 _site/assets/css/style.css "$NEWS_DIR/assets/css/style.css"

  # Images, derived from the artifacts rather than hardcoded, so a layout
  # change that adds one brings it across.
  grep -ho '/assets/images/[A-Za-z0-9._-]*' _site/news.html "$TPL" \
    | sort -u | while read -r path; do
        src="_site${path}"
        [ -f "$src" ] || { echo "  missing: $src" >&2; exit 1; }
        install -D -m 644 "$src" "$NEWS_DIR${path}"
      done

  echo "Artifacts placed. Review and push with umt."
elif [ -f "$TPL" ]; then
  echo "No newsletter checkout at $NEWS_DIR — skipping artifact placement"
fi

# Not a deliverable of this site, in any environment.
rm -rf _site/listmonk

echo "Build completed successfully! (backlinks: ${BL_STATUS:-ok})"
