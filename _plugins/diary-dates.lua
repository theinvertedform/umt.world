-- _plugins/diary-dates.lua
--
-- Renders a heading whose entire text is an ISO date as a display form,
-- leaving the identifier alone. gfm_auto_identifiers assigns ids at the
-- reader stage, from source heading text, so `## 2023-09-01` anchors at
-- #2023-09-01 no matter what this writes into the node. The filter
-- decorates; it never mints.
--
-- The escape hatch is a heading attribute:
--
--     ## 2023-05-02 {display="Now"}
--
-- which renders "Now" over an anchor that is still the date. Anatomy's
-- repeated `## Now` headings need this; the date is real (or in-world) and
-- the display is the diary's voice.
--
-- Scope is structural, not per-page: Jekyll strips frontmatter before the
-- converter, so no document metadata is available to gate on. The guard is
-- that the heading text must be a bare ISO date and nothing else.
--
-- The ISO date survives as an attribute on the rendered element.

local FORMAT = 'weekday'   -- weekday | long | kafka | iso

local DAYS = {
  'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
}

local MONTHS = {
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
}

local ROMAN = {
  'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII'
}

local function parse(s)
  local y, m, d = s:match('^(%d%d%d%d)%-(%d%d)%-(%d%d)$')
  if not y then return nil end
  return tonumber(y), tonumber(m), tonumber(d)
end

-- hour=12 rather than the default midnight: it puts the timestamp clear of
-- any DST transition, so the weekday cannot slip by one.
-- os.date('*t').wday is locale-independent; os.date('%A') is not.
local function weekday(y, m, d)
  local t = os.time { year = y, month = m, day = d, hour = 12 }
  if not t then return nil end
  return DAYS[os.date('*t', t).wday]
end

local FORMATTERS = {
  iso = function(y, m, d)
    return string.format('%04d-%02d-%02d', y, m, d)
  end,

  weekday = function(y, m, d)
    return weekday(y, m, d)
  end,

  long = function(y, m, d)
    local w = weekday(y, m, d)
    if not w then return nil end
    return string.format('%s, %d %s %d', w, d, MONTHS[m], y)
  end,

  -- Kafka's diary convention: day, month in Roman numerals, two-digit year.
  kafka = function(y, m, d)
    return string.format('%d %s %02d', d, ROMAN[m], y % 100)
  end,
}

-- A label goes into the AST as words and spaces, not one Str carrying
-- literal blanks, so that writers other than HTML break it correctly.
local function inlines(s)
  local out = {}
  for word in s:gmatch('%S+') do
    if #out > 0 then out[#out + 1] = pandoc.Space() end
    out[#out + 1] = pandoc.Str(word)
  end
  return out
end

function Header(el)
  local y, m, d = parse(pandoc.utils.stringify(el.content))
  if not y then return nil end

  local iso = string.format('%04d-%02d-%02d', y, m, d)
  local label = el.attributes.display

  if label then
    el.attributes.display = nil
  else
    local fmt = FORMATTERS[FORMAT] or FORMATTERS.weekday
    label = fmt(y, m, d)
    if not label then
      io.stderr:write('diary-dates: unformattable date ' .. iso .. '\n')
      return nil
    end
  end

  el.content = inlines(label)
  el.attributes.date = iso
  return el
end
