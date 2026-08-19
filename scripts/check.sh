#!/usr/bin/env bash
# Assert the invariants ARCHITECTURE.md declares. Exit 1 on any violation.
#   check.sh env    — preconditions; runnable before `bundle install`
#   check.sh site   — assertions over _site; requires a completed build
#   check.sh        — both
#
# check_env must run without the bundle (build.sh calls it first), so it uses
# bare `ruby` and stdlib only. check_site needs nokogiri and so runs under
# `bundle exec` — locally the gem is on the system load path, in CI it is not.
set -uo pipefail
cd "$(dirname "$0")/.."

RUBY=${RUBY:-bundle exec ruby}

fail=0
err() { printf 'CHECK FAIL: %s\n' "$*" >&2; fail=1; }

check_env() {
  local want have xml
  want=$(ruby -ryaml -e 'puts YAML.load_file("_config.yml")["pandoc"]["version"]') \
    || { err "cannot read pandoc.version from _config.yml"; return; }
  have=$(pandoc --version | head -1 | cut -d' ' -f2) \
    || { err "pandoc not on PATH"; return; }
  [[ "$have" == "$want" ]] || err "pandoc $have, _config.yml says $want"

  # Local-only: portage bumps libxml2 without rebuilding the gem. CI builds
  # nokogiri fresh, so this is vacuous there.
  xml=$($RUBY -rnokogiri -e 'i=Nokogiri::VERSION_INFO["libxml"]; puts i["compiled"]==i["loaded"] ? "" : "#{i["compiled"]} vs #{i["loaded"]}"' 2>/dev/null) || return
  [[ -z "$xml" ]] || err "nokogiri libxml mismatch: $xml — emerge -1 dev-ruby/nokogiri"
}

check_site() {
  [[ -d _site ]] || { err "_site absent — build first"; return; }

  # One id per element per page. Violations come from the second authority:
  # hand-authored levelN pages, and headings slugging onto layout-owned ids.
  local dupes
  dupes=$($RUBY -rnokogiri -e '
    Dir.glob("_site/**/*.html").sort.each do |f|
      ids = Nokogiri::HTML(File.read(f)).css("[id]").map { |e| [e["id"], e.name] }
      ids.group_by(&:first).select { |_, v| v.size > 1 }.each do |id, v|
        puts "#{f}: #{id} → #{v.map(&:last).join(", ")}"
      end
    end
  ') || err "duplicate-id scan failed"
  [[ -z "$dupes" ]] || err "duplicate ids:"$'\n'"$dupes"

  # Invariant 3: every TOC href resolves to a section pandoc minted.
  # Nokogiri percent-encodes non-ASCII fragments on re-serialization; the
  # target id stays literal, hence CGI.unescape. #backlinks is appended by
  # Toc explicitly and has no section in the scan root.
  local anchors
  anchors=$($RUBY -rnokogiri -e '
    require "cgi"
    Dir.glob("_site/**/*.html").sort.each do |f|
      d   = Nokogiri::HTML(File.read(f))
      toc = d.css("#TOC a[href^=\"#\"]")
      next if toc.empty?
      sec = d.css("section[id]").map { |s| s["id"] }
      bad = toc.map { |a| CGI.unescape(a["href"][1..]) } - sec - ["backlinks"]
      puts "#{f}: dangling → #{bad.join(", ")}" unless bad.empty?
    end
  ') || err "anchor scan failed"
  [[ -z "$anchors" ]] || err "dangling TOC anchors:"$'\n'"$anchors"

  # One pandoc document per page. A second #refs/#footnotes/#bibliography
  # means converted HTML from N documents was concatenated — ARCH §4.2.
  local multi
  multi=$($RUBY -rnokogiri -e '
    Dir.glob("_site/**/*.html").sort.each do |f|
      d = Nokogiri::HTML(File.read(f))
      %w[bibliography footnotes refs].each do |id|
        n = d.css("##{id}").size
        puts "#{f}: #{n}× ##{id}" if n > 1
      end
    end
  ') || err "single-document scan failed"
  [[ -z "$multi" ]] || err "page assembled from multiple pandoc documents:"$'\n'"$multi"

  # serve overrides site.url; its _site must never be deployed. ARCH §10.
  local host
  host=$(grep -rlE 'localhost|127\.0\.0\.1' _site \
    --include='*.html' --include='*.xml' --include='*.json' --include='*.tpl' 2>/dev/null)
  [[ -z "$host" ]] || err "localhost in built output:"$'\n'"$host"

  # diary-dates.lua fails silently: entries render as bare ISO dates instead
  # of weekdays. A dated section id with no data-date means it did not run.
  local dates
  dates=$($RUBY -rnokogiri -e '
    Dir.glob("_site/**/*.html").sort.each do |f|
      bad = Nokogiri::HTML(File.read(f)).css("section[id]").select { |s|
        s["id"] =~ /\A\d{4}-\d\d-\d\d\z/ && s["data-date"].nil?
      }
      puts "#{f}: #{bad.map { |s| s["id"] }.join(", ")}" unless bad.empty?
    end
  ') || err "diary date scan failed"
  [[ -z "$dates" ]] || err "diary entries missing data-date:"$'\n'"$dates"

  # error on backlinks
  local bl
  bl=$($RUBY -rjson -e '
    f = "_data/backlinks/all_backlinks.json"
    abort "missing" unless File.exist?(f)
    d = JSON.parse(File.read(f))
    n = d.values.sum(&:size)
    puts "#{n} links across #{d.size} targets" if n.zero?
  ') || err "backlink data unreadable"
  [[ -z "$bl" ]] || err "backlinks empty: $bl"
}

case "${1-all}" in
  env)  check_env ;;
  site) check_site ;;
  all)  check_env; check_site ;;
  *)    err "unknown mode: $1" ;;
esac

exit $fail
