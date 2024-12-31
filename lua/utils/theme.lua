local themes = {
  { name = 'terafox', alt_name = 'nightfox', lualine = 'auto' },
  { name = 'duskfox', alt_name = 'nightfox', lualine = 'auto' },
  { name = 'nightfox', alt_name = 'nightfox', lualine = 'auto' },
  { name = 'carbonfox', alt_name = 'nightfox', lualine = 'auto' },
}

local index = 1
local hour = tonumber(os.date("%H"))
if hour >= 6 and hour < 16 then
  index = 1
elseif hour >= 16 and hour < 21 then
  index = 2
elseif hour >= 21 or hour < 6 then
  index = 3
end
index = 1

local M = {}
function M.get_current_theme()
  return themes[index].name
end

function M.get_current_lualine_theme()
  return themes[index].lualine
end

require('plugins.themes.' .. M.get_current_theme())

return M
