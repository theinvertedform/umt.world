-- entities.lua — resolve @agent / @venue citations to inward entity links.
-- MUST be placed before --citeproc in the extensions array, so citeproc
-- never sees these Cite nodes and they cannot enter the bibliography.

local stringify = pandoc.utils.stringify

local BIB   = "collections/entities.bib"
local PATHS = { agent = "/people#", venue = "/places#" }

local entities = {}   -- key -> {kind, full, short, url}
local seen     = {}   -- key -> true once mentioned in this document

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
  -- VERIFY: that the biblatex reader populates meta.references.
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
        full = ref.title and stringify(ref.title) or id
        -- VERIFY: key name for shorttitle. Try "title-short", then "shortTitle".
        local st = ref["title-short"] or ref["shortTitle"]
        short = st and stringify(st) or full
      end
      entities[id] = {
        kind  = kind,
        full  = full,
        short = short,
        url   = ref.URL and stringify(ref.URL) or nil,
      }
    end
  end
end

load_entities()

-- [@greig, the artist] -> suffix is the override label.
-- VERIFY: whether pandoc leaves the comma on the suffix. Stripped here if so.
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

  local label = clean_suffix(c.suffix)
  if #label == 0 then
    label = to_inlines(seen[c.id] and e.short or e.full)
  end
  seen[c.id] = true

  -- Print has no /people page to point at; render the name only.
  if FORMAT:match("latex") or FORMAT:match("docx") then
    return label
  end

  local alt_mode = false

  -- inside the Cite handler, replacing the label/seen block:
    local label = clean_suffix(c.suffix)
    if #label == 0 then
      local form = (not alt_mode and seen[c.id]) and e.short or e.full
      label = to_inlines(form)
    end
    if alt_mode then return label end        -- links in alt are meaningless
    seen[c.id] = true

  return pandoc.Link(
    label,
    PATHS[e.kind] .. c.id,
    "",
    pandoc.Attr("", {}, { ["data-entity"] = e.kind })
  )
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
