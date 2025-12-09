local M = {}

local index = 2
local themes = {
  { name = 'gruvbox',         lualine = 'auto' },       -- brown
  { name = 'terafox',         lualine = 'auto' },       -- green
  { name = 'duskfox',         lualine = 'auto' },       -- "bright" purple
  { name = 'nightfox',        lualine = 'auto' },       -- blue
  { name = 'carbonfox',       lualine = 'auto' },       -- midnight brown
  { name = 'ayu',             lualine = 'ayu' },        -- midnight blue
  { name = 'kanagawa-wave',   lualine = 'auto' },       -- pastel purple
  { name = 'kanagawa-dragon', lualine = 'auto' },       -- pastel brown
  { name = 'kanagawa-lotus',  lualine = 'auto' },       -- gold paper
  { name = 'tokyonight',      lualine = 'tokyonight' }, -- purple
  { name = 'default',         lualine = 'auto' },       -- midnight
}

function M.current_theme()
  return themes[index].name
end

function M.current_lualine_theme()
  return themes[index].lualine
end

if vim.g.vscode then
  return M
end

local hour = tonumber(os.date("%H"))
if hour >= 9 and hour < 13 then
  -- morning
  index = 2
elseif hour >= 13 and hour < 17 then
  -- day
  index = 2
elseif hour >= 17 and hour < 21 then
  -- dusk
  index = 10
elseif hour >= 21 or hour < 1 then
  -- early night
  index = 4
elseif hour >= 1 and hour < 5 then
  -- deep night
  index = 4
elseif hour >= 5 and hour < 9 then
  -- early morning
  index = 10
end

require('plugins.themes.' .. M.current_theme())

return M
