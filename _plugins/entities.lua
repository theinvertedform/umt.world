-- entities.lua — resolve entity and work citations before citeproc runs.
-- MUST be placed before --citeproc in the extensions array, so citeproc
-- never sees the entity Cite nodes and they cannot enter the bibliography.
--
-- Entities (agents, venues) — entities.bib, never passed to --bibliography:
--   @greig                  first mention -> linked full name; later -> short
--   [@greig, the artist]    suffix overrides the label
--
-- Works (artwork, video, movie, music) — bibliography.bib, citeproc sees them:
--   @steyerl2014            author-in-text -> italic title inline
--   [@steyerl2014]          untouched -> ordinary footnote
-- Consumed work keys are handed back to citeproc as `nocite` so they still
-- appear in the bibliography.
--
-- Every entity mention carries data-entity for the JSON-LD mentions scan;
-- only the first is an <a>, so each entity yields one backlink per page.

local stringify = pandoc.utils.stringify

local BIB   = "collections/entities.bib"
local BIBW  = "collections/bibliography.bib"
local PATHS = { agent = "/people#", venue = "/places#" }

-- Bare @key renders the title inline only for these entry types. Books and
-- articles keep ordinary author-in-text citation behaviour.
local WORK_TYPES = { artwork = true, video = true, movie = true, music = true }

local entities    = {}   -- key -> {kind, full, short}
local works       = {}   -- key -> {full, short}
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

-- Entry type is discarded by the CSL layer (custom types return empty),
-- so read it off the raw source instead.
local function entry_types(src)
  local kinds = {}
  for t, k in src:gmatch("@(%a+)%s*{%s*([^,%s]+)") do
    kinds[k] = t:lower()
  end
  return kinds
end

local function load_entities()
  local src = read_file(BIB)
  if not src then return end
  local kinds = entry_types(src)

  local doc = pandoc.read(src, "biblatex")
  for _, ref in ipairs(doc.meta.references or {}) do
    local id   = stringify(ref.id)
    local kind = kinds[id]
    if PATHS[kind] then
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
        full  = ref.title and stringify(ref.title) or id
        short = ref["title-short"] and stringify(ref["title-short"]) or full
      end
      entities[id] = { kind = kind, full = full, short = short }
    end
  end
end

local function load_works()
  local src = read_file(BIBW)
  if not src then return end
  local kinds = entry_types(src)

  local doc = pandoc.read(src, "biblatex")
  for _, ref in ipairs(doc.meta.references or {}) do
    local id = stringify(ref.id)
    if WORK_TYPES[kinds[id]] then
      if ref.title then
        works[id] = {
          full  = stringify(ref.title),
          short = ref["title-short"] and stringify(ref["title-short"])
                  or stringify(ref.title),
        }
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
    label = to_inlines((first or alt_mode) and rec.full or rec.short)
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
    if not alt_mode then
      if first then consumed[#consumed + 1] = c.id end
      seen[c.id] = true
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
    Cite   = Cite,
    Pandoc = add_nocite,
  }
}
