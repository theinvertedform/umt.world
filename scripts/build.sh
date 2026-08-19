#!/bin/bash
set -e

./scripts/check.sh env

# Install required gems
echo "Installing gems..."
[[ -n "${CI:-}" ]] || bundle install

# Build the site
echo "Building Jekyll site..."
JEKYLL_ENV=production bundle exec jekyll build

# Generate backlinks. A failure is tolerable locally — you still get a
# previewable site — but in CI it means deploying a dead hypertext apparatus.
BACKLINKS=skipped
if [ -f "scripts/generate_backlinks.rb" ]; then
  echo "Generating backlinks..."
  if bundle exec ruby scripts/generate_backlinks.rb --site-dir . --html-dir _site --output-dir _data/backlinks; then
    BACKLINKS=ok
    echo "Rebuilding Jekyll site with backlinks..."
    JEKYLL_ENV=production bundle exec jekyll build
  else
    BACKLINKS=failed
    if [ -n "${CI:-}" ] || [ "${JEKYLL_ENV:-}" = production ]; then
      echo "FATAL: backlinks generation failed; refusing to deploy stale output" >&2
      exit 1
    fi
    echo "WARNING: backlinks generation failed — _site holds pass-1 output" >&2
  fi
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

if [ "$BACKLINKS" = failed ]; then
  echo "Build completed with errors. (backlinks: failed)"
else
  echo "Build completed. (backlinks: $BACKLINKS)"
fi
