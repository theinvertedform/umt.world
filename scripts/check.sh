#!/usr/bin/env bash
# Assert the invariants ARCHITECTURE.md declares. Exit 1 on any violation.
#   check.sh env    — preconditions; runnable before a build
#   check.sh site   — assertions over _site; requires a completed build
#   check.sh        — both
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
err() { printf 'CHECK FAIL: %s\n' "$*" >&2; fail=1; }

check_env() {
  local want have
  want=$(ruby -ryaml -e 'puts YAML.load_file("_config.yml")["pandoc"]["version"]') \
    || { err "cannot read pandoc.version from _config.yml"; return; }
  have=$(pandoc --version | head -1 | cut -d' ' -f2) \
    || { err "pandoc not on PATH"; return; }
  [[ "$have" == "$want" ]] || err "pandoc $have, _config.yml says $want"

  local xml
  xml=$(ruby -rnokogiri -e 'i=Nokogiri::VERSION_INFO["libxml"]; puts i["compiled"]==i["loaded"] ? "" : "#{i["compiled"]} vs #{i["loaded"]}"' 2>/dev/null)
  [[ -z "$xml" ]] || err "nokogiri libxml mismatch: $xml — emerge -1 dev-ruby/nokogiri"
}

check_site() {
  [[ -d _site ]] || { err "_site absent — build first"; }

  local dupes
  dupes=$(ruby -rnokogiri -e '
    Dir.glob("_site/**/*.html").sort.each do |f|
      ids = Nokogiri::HTML(File.read(f)).css("[id]").map { |e| [e["id"], e.name] }
      ids.group_by(&:first).select { |_, v| v.size > 1 }.each do |id, v|
        puts "#{f}: #{id} → #{v.map(&:last).join(", ")}"
      end
    end
  ') || { err "duplicate-id scan failed"; }
  [[ -z "$dupes" ]] || err "duplicate ids:"$'\n'"$dupes"

  anchors=$(ruby -rnokogiri -e '
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
}

case "${1-all}" in
  env)  check_env ;;
  site) check_site ;;
  all)  check_env; check_site ;;
  *)    err "unknown mode: $1" ;;
esac

exit $fail
