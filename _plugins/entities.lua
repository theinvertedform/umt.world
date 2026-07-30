-- entities.lua — resolve @agent / @venue citations to inward entity links.
-- MUST be placed before --citeproc in the extensions array, so citeproc
-- never sees these Cite nodes and they cannot enter the bibliography.
--
-- Syntax:
--   @greig                  first mention -> linked full name; later -> short
--   [@greig, the artist]    suffix overrides the label
--
-- Every mention carries data-entity for the JSON-LD mentions scan; only the
-- first is an <a>, so each entity yields one backlink per page.

local stringify = pandoc.utils.stringify

local BIB   = "collections/entities.bib"
local PATHS = { agent = "/people#", venue = "/places#" }

local entities = {}   -- key -> {kind, full, short}
local seen     = {}   -- key -> true once mentioned in this document
local alt_mode = false

local function to_inlines(s)
  local out = {}
  for w in s:gmatch("%S+") do
    if #out > 0 then out[#out + 1] = pandoc.Space() end
    out[#out + 1] = pandoc.Str(w)
  end
  return out
end

local function load_entities()
  local fh = io.open(BIB, "r")
  if not fh then
    io.stderr:write("entities.lua: cannot read " .. BIB .. "\n")
    return
  end
  local src = fh:read("a")
  fh:close()

  -- Entry type is discarded by the CSL layer (custom types return empty),
  -- so read it off the raw source instead.
  local kinds = {}
  for t, k in src:gmatch("@(%a+)%s*{%s*([^,%s]+)") do
    kinds[k] = t:lower()
  end

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
        full  = (given ~= "" and (given .. " " .. family)) or family
        short = (family ~= "" and family) or full
      else
        full  = ref.title and stringify(ref.title) or id
        short = ref["title-short"] and stringify(ref["title-short"]) or full
      end
      entities[id] = { kind = kind, full = full, short = short }
    end
  end
end

load_entities()

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

function Cite(elem)
  if #elem.citations ~= 1 then return nil end   -- [@a; @b] is a real citation
  local c = elem.citations[1]
  local e = entities[c.id]
  if not e then return nil end                  -- pass through to citeproc

  local first = not seen[c.id]
  local label = clean_suffix(c.suffix)
  if #label == 0 then
    label = to_inlines((first or alt_mode) and e.full or e.short)
  end

  -- Alt text is plain and never advances first-mention state.
  if alt_mode then return label end
  seen[c.id] = true

  -- Print has no /people page to point at; render the name only.
  if FORMAT:match("latex") or FORMAT:match("docx") then
    return label
  end

  local attr = pandoc.Attr("", {}, { ["data-entity"] = e.kind })
  if first then
    return pandoc.Link(label, PATHS[e.kind] .. c.id, "", attr)
  end
  return pandoc.Span(label, attr)
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
  }
}
