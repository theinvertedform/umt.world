# _plugins/post_render.rb
#
# One :post_render pass over the finished page. This file owns the hook, the
# Nokogiri parse, the job order, and serialization. It owns no transformation
# of its own — every edit to the document lives in a job under post_render/.
#
# Identifier authority is pandoc. Nothing in this subsystem mints a section or
# heading id; ids are read from the section[id] elements section_divs produces.
# The Footnotes heading is the sole insertion, and it borrows the id pandoc
# already put on the enclosing section. Dropcaps mint class names only.
#
# Jobs are required explicitly rather than left to Jekyll's plugin glob.
# Jekyll requires _plugins/**/*.rb sorted, and "post_render.rb" sorts before
# "post_render/…" ('.' is 0x2E, '/' is 0x2F) — so this file loads first and
# could not otherwise name the job constants. Jekyll's subsequent require of
# the same absolute paths is a no-op.

require 'nokogiri'

require_relative 'post_render/shared'
require_relative 'post_render/link_ids'
require_relative 'post_render/footnotes'
require_relative 'post_render/self_links'
require_relative 'post_render/toc'
require_relative 'post_render/dropcaps'

module PostRender
  # Order is load-bearing, and only in the places noted. Read this as the
  # specification, not as an accident of the sequence of calls below.
  #
  #   LinkIds    — order-independent. Matches a[href^="/"]; every anchor the
  #                later jobs emit is fragment-only, so it cannot collide.
  #   Footnotes  — MUST precede Toc. pandoc emits <section id="footnotes"> with
  #                no heading; the walk skips a section that has an id but no
  #                heading. Without this job first, Footnotes leaves the TOC.
  #   SelfLinks  — before Toc by convention only. Toc reads heading.text, which
  #                is unchanged by wrapping the children in a.anchor.
  #   Toc        — reads section#backlinks for its label; that section is
  #                authored in post.html and exists before this pass.
  #   Dropcaps   — last. It is the only job that inspects prose rather than
  #                structure, and it should see the document the reader gets.
  JOBS = [
    ['link-ids',   LinkIds],
    ['footnotes',  Footnotes],
    ['self-links', SelfLinks],
    ['toc',        Toc],
    ['dropcaps',   Dropcaps]
  ].freeze

  # One rescue per job, not one for the pass. A failure in dropcaps must not
  # withdraw the page's link-* ids, which would silently remove it from
  # scripts/generate_backlinks.rb's scan. (ARCHITECTURE Reg. 66.)
  def self.process(item)
    return unless item.output_ext == '.html'
    return if item.output.nil? || item.output.empty?

    doc = Nokogiri::HTML(item.output)
    modified = false

    JOBS.each do |name, job|
      begin
        modified |= job.call(doc, item)
      rescue => e
        Jekyll.logger.error 'PostRender:', "#{name} failed on #{item.path}: #{e.message}"
        Jekyll.logger.debug 'PostRender:', e.backtrace.first(5).join("\n")
      end
    end

    item.output = doc.to_html if modified
  end
end

Jekyll::Hooks.register [:documents, :pages], :post_render do |item|
  PostRender.process(item)
end
