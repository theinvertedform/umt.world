-- metadata-headings.lua
-- Filter that adds section headings for Footnotes, Backlinks, Similar Links, and Bibliography
-- when these elements are present in the document

-- Track if we've seen these elements in the document
local has_citations = false

-- Check for citations in the document
function Cite(el)
  has_citations = true
  return el
end

-- Helper function to check if a block contains a section with the given ID
local function find_section_by_id(blocks, id)
  for i, block in ipairs(blocks) do
    -- Check for both Div and RawBlock for maximum compatibility
    if (block.t == "Div" and block.identifier == id) or
       (block.t == "RawBlock" and block.format == "html" and block.text:match('<section[^>]*id="' .. id .. '"[^>]*>')) then
      return i
    end
  end
  return nil
end

-- Lowest heading level used in the document; 1 if there are none
local function min_header_level(blocks)
  local level = nil
  for _, block in ipairs(blocks) do
    if block.t == "Header" then
      if level == nil or block.level < level then
        level = block.level
      end
    end
  end
  return level or 1
end

-- Process the document after all other filters
function Pandoc(doc)
  -- Keep track of which sections were found and where they are
  local section_positions = {}

  -- Find all the sections in the document
  local refs_pos = find_section_by_id(doc.blocks, "refs")
  local level = min_header_level(doc.blocks)

  -- Placeholders for backlinks and similar links (for future implementation)

  if has_citations and refs_pos then
    table.insert(section_positions, {
      pos = refs_pos,
      header = pandoc.Header(level, "Bibliography"),
      id = "bibliography"
    })
  end

  -- Sort the sections by position to maintain document order
  table.sort(section_positions, function(a, b) return a.pos < b.pos end)

  -- Insert headers at the appropriate positions
  -- We need to insert from end to beginning to avoid affecting positions
  for i = #section_positions, 1, -1 do
    local section = section_positions[i]
    section.header.identifier = section.id
    table.insert(doc.blocks, section.pos, section.header)
  end

  return doc
end
