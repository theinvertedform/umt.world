-- entities.lua — resolve entity and work citations before citeproc runs.
-- MUST be placed before --citeproc in the extensions array, so citeproc
-- never sees the entity Cite nodes and they cannot enter the bibliography.
--
-- Entities (agents, venues) — entities.bib, never passed to --bibliography:
--   @greig                  first mention -> linked full name; later -> short
--   [@greig, the artist]    suffix overrides the label
--
-- Works — bibliography.bib, citeproc sees them:
--   @steyerl2014            author-in-text -> title inline, styled per type
--   [@steyerl2014]          untouched -> ordinary footnote
-- Standalone works render in italics; parts of larger works render in
-- quotation marks (CMOS 8.163ff, 14.215). See WORK_TYPES.
-- Consumed work keys are handed back to citeproc as `nocite` so they still
-- appear in the bibliography.
--
-- Every entity mention carries data-entity for the JSON-LD mentions scan;
-- only the first is an <a>, so each entity yields one backlink per page.
--
-- Titles and entry types are read from the raw .bib source, NOT from
-- pandoc's biblatex reader. The reader sentence-cases English titles on
-- import (citeproc restores the case at render time via text-case="title",
-- which never runs on nodes this filter has already replaced) and returns
-- an empty type for custom entry types. The .bib is therefore the casing
-- authority for inline mentions; citeproc remains the authority for notes
-- and the bibliography. Store titles in the case you want to read.

local stringify = pandoc.utils.stringify

local BIB   = "collections/entities.bib"
local BIBW  = "collections/bibliography.bib"
local PATHS = { agent = "/people#", venue = "/places#" }

-- Bare @key renders the title inline for these entry types, in this style.
-- House usage: @inbook is a self-contained work inside an omnibus (italic);
-- @incollection is an essay or chapter within a collection (quoted).
local WORK_TYPES = {
  artwork        = "emph",
  book           = "emph",
  inbook         = "emph",
  booklet        = "emph",
  collection     = "emph",
  manual         = "emph",
  movie          = "emph",
  music          = "emph",
  online         = "emph",
  periodical     = "emph",
  proceedings    = "emph",
  report         = "emph",
  video          = "emph",

  article        = "quoted",
  incollection   = "quoted",
  inproceedings  = "quoted",
  suppperiodical = "quoted",
  thesis         = "quoted",
  unpublished    = "quoted",
}

local entities    = {}   -- key -> {kind, full, short}
local works       = {}   -- key -> {full, style}
local seen        = {}   -- key -> true once mentioned in this document
local consumed    = {}   -- ordered work keys the filter removed from the AST
local alt_mode    = false
-- Entity pages don't exist yet. Set true once /people and /places ship.
local LINK_ENTITIES = false

local function to_inlines(s)
  local out = {}
  for w in s:gmatch("%S+") do
    if #out > 0 then out[#out + 1] = pandoc.Space() end
    out[#out + 1] = pandoc.Str(w)
  end
  return out
end

local function read_file(path)
  local fh = io.open(path, "r")
  if not fh then
    io.stderr:write("entities.lua: cannot read " .. path .. "\n")
    return nil
  end
  local src = fh:read("a")
  fh:close()
  return src
end

-- Strip the trailing comma, the outer delimiters, any brace protection, and
-- backslash escapes, leaving display text.
local function clean_field(s)
  s = s:gsub(",%s*$", "")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("^[{\"]+", ""):gsub("[}\"]+$", "")
  s = s:gsub("[{}]", "")
  s = s:gsub("\\([&%%%$#_])", "%1")
  return s
end

-- Harvest entry type, title, and shorttitle straight from the source.
-- Assumes one field per line, which canonical .bib formatting guarantees;
-- a title wrapped across lines will be truncated at the first newline.
local function entry_fields(src)
  local out, key = {}, nil
  for line in src:gmatch("[^\n]+") do
    local t, k = line:match("^%s*@(%a+)%s*{%s*([^,%s]+)")
    if t then
      key = k
      out[key] = { kind = t:lower() }
    elseif key then
      if line:match("^%s*}%s*$") then
        key = nil
      else
        -- The ^%s* anchor keeps `shorttitle` from matching the title pattern.
        local ti = line:match("^%s*title%s*=%s*(.+)$")
        local sh = line:match("^%s*shorttitle%s*=%s*(.+)$")
        if ti then out[key].title      = clean_field(ti) end
        if sh then out[key].shorttitle = clean_field(sh) end
      end
    end
  end
  return out
end

-- Agents need pandoc's name parser for the family/given split; venues take
-- their label from the raw title.
local function load_entities()
  local src = read_file(BIB)
  if not src then return end
  local fields = entry_fields(src)

  local doc = pandoc.read(src, "biblatex")
  for _, ref in ipairs(doc.meta.references or {}) do
    local id = stringify(ref.id)
    local f  = fields[id] or {}
    if PATHS[f.kind] then
      local full, short
      if ref.author and #ref.author > 0 then
        local a      = ref.author[1]
        local family = a.family and stringify(a.family) or ""
        local given  = a.given  and stringify(a.given)  or ""
        if family == "" and given == "" then
          io.stderr:write("entities.lua: " .. id ..
            " has an unparsed name; check for double braces on author\n")
          full, short = id, id
        else
          full  = (given ~= "" and (given .. " " .. family)) or family
          short = (family ~= "" and family) or full
        end
      else
        full  = f.title or id
        short = f.shorttitle or full
      end
      entities[id] = { kind = f.kind, full = full, short = short }
    end
  end
end

-- No biblatex parse here: everything needed is in the raw source, and
-- anything the reader returns has already been sentence-cased.
local function load_works()
  local src = read_file(BIBW)
  if not src then return end

  for id, f in pairs(entry_fields(src)) do
    local style = WORK_TYPES[f.kind]
    if style then
      if f.title then
        works[id] = { full = f.title, style = style }
      else
        io.stderr:write("entities.lua: " .. id ..
          " is a work entry with no title field\n")
      end
    end
  end
end

load_entities()
load_works()

-- Pandoc hands back the suffix with its leading comma and space attached.
local function clean_suffix(suffix)
  if not suffix then return {} end
  local out = {}
  for _, el in ipairs(suffix) do out[#out + 1] = el end
  while #out > 0 and (out[1].t == "Space" or
                     (out[1].t == "Str" and out[1].text == ",")) do
    table.remove(out, 1)
  end
  return out
end

local function label_for(c, rec)
  local first = not seen[c.id]
  local label = clean_suffix(c.suffix)
  if #label == 0 then
    -- Works have no short form: repeat-mention shortening and ibid. are the
    -- citation style's job, not this filter's. Entities do (surname only).
    local text = rec.full
    if not (first or alt_mode) then text = rec.short or rec.full end
    label = to_inlines(text)
  end
  return label, first
end

function Cite(elem)
  if #elem.citations ~= 1 then return nil end   -- [@a; @b] is a real citation
  local c = elem.citations[1]
  local e = entities[c.id]

  if not e then
    -- Bracketed work citations belong to citeproc; only bare ones render here.
    local w = works[c.id]
    if not (w and c.mode == "AuthorInText") then return nil end
    local label, first = label_for(c, w)

    -- Alt text is plain: no markup, no quote characters, no state change.
    if alt_mode then return label end

    if first then consumed[#consumed + 1] = c.id end
    seen[c.id] = true

    if w.style == "quoted" then
      return pandoc.Quoted(pandoc.DoubleQuote, label)
    end
    return pandoc.Emph(label)
  end

  local label, first = label_for(c, e)

  -- Alt text is plain and never advances first-mention state.
  if alt_mode then return label end
  seen[c.id] = true

  -- Print has no /people page to point at; render the name only.
  if FORMAT:match("latex") or FORMAT:match("docx") then
    return label
  end

  local attr = pandoc.Attr("", {}, { ["data-entity"] = e.kind })
  if first and LINK_ENTITIES then
    return pandoc.Link(label, PATHS[e.kind] .. c.id, "", attr)
  end
  return pandoc.Span(label, attr)
end

-- Works whose Cite nodes were replaced are invisible to citeproc, so declare
-- them in nocite to keep them in the bibliography.
local function add_nocite(doc)
  if #consumed == 0 then return nil end

  local inlines = {}
  local existing = doc.meta.nocite
  if existing then
    for _, el in ipairs(existing) do inlines[#inlines + 1] = el end
  end
  for _, id in ipairs(consumed) do
    if #inlines > 0 then
      inlines[#inlines + 1] = pandoc.Str(",")
      inlines[#inlines + 1] = pandoc.Space()
    end
    inlines[#inlines + 1] = pandoc.Cite(
      { pandoc.Str("@" .. id) },
      { pandoc.Citation(id, "NormalCitation") }
    )
  end

  doc.meta.nocite = pandoc.MetaInlines(inlines)
  return doc
end

return {
  {
    traverse = 'topdown',
    Image = function(el)
      alt_mode = true
      el.caption = el.caption:walk({ Cite = Cite })
      alt_mode = false
      return el, false
    end,
    Cite = Cite,
  },
  { Pandoc = add_nocite },
}
