local themes = {
  { name = 'gruvbox', lualine = 'auto' },
  { name = 'terafox', lualine = 'auto' },
  { name = 'duskfox', lualine = 'auto' },
  { name = 'nightfox', lualine = 'auto' },
  { name = 'carbonfox', lualine = 'auto' },
  { name = 'ayu', lualine = 'ayu' },
  { name = 'kanagawa', lualine = 'auto' },
  { name = 'tokyonight', lualine = 'tokyonight' },
  { name = 'default', lualine = 'auto' },
}

local index = 2
local hour = tonumber(os.date("%H"))
if hour >= 9 and hour < 13 then
  -- morning
  index = 2
elseif hour >= 13 and hour < 17 then
  -- day
  index = 2
elseif hour >= 17 and hour < 21 then
  -- dusk
  index = 4
elseif hour >= 21 or hour < 1 then
  -- early night
  index = 8
elseif hour >= 1 and hour < 5 then
  -- deep night
  index = 5
elseif hour >= 5 and hour < 9 then
  -- early morning
  index = 5
end
-- index = 9

local M = {}
function M.get_current_theme()
  return themes[index].name
end

function M.get_current_lualine_theme()
  return themes[index].lualine
end

require('plugins.themes.' .. M.get_current_theme())

return M
