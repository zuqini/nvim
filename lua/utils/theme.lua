local M = {}

local index = 2
local themes = {
  { name = 'gruvbox',         lualine = 'auto',       transparent = true },  -- brown
  { name = 'terafox',         lualine = 'auto',       transparent = true },  -- green
  { name = 'duskfox',         lualine = 'auto',       transparent = true },  -- "bright" purple
  { name = 'nightfox',        lualine = 'auto',       transparent = true },  -- blue
  { name = 'carbonfox',       lualine = 'auto',       transparent = true },  -- midnight brown
  { name = 'kanagawa-wave',   lualine = 'auto',       transparent = false }, -- pastel purple
  { name = 'kanagawa-dragon', lualine = 'auto',       transparent = false }, -- pastel brown
  { name = 'kanagawa-lotus',  lualine = 'auto',       transparent = false }, -- gold paper
  { name = 'tokyonight',      lualine = 'tokyonight', transparent = true },  -- purple
  { name = 'default',         lualine = 'auto',       transparent = true },  -- midnight
}

function M.current_theme()
  return themes[index].name
end

function M.current_lualine_theme()
  return themes[index].lualine
end

function M.current_theme_transparent()
  return themes[index].transparent
end

if vim.g.vscode then
  return M
end

function M.select_theme_by_time()
  local hour = tonumber(os.date("%H"))
  if hour >= 9 and hour < 13 then
    index = 2
  elseif hour >= 13 and hour < 17 then
    index = 2
  elseif hour >= 17 and hour < 21 then
    index = 9
  elseif hour >= 21 or hour < 1 then
    index = 4
  elseif hour >= 1 and hour < 5 then
    index = 4
  elseif hour >= 5 and hour < 9 then
    index = 9
  end
  require('plugins.themes.' .. M.current_theme()).setup()
  if themes[index].transparent then
    require('utils').set_transparent_background()
  end
end

M.select_theme_by_time()

local timer = vim.uv.new_timer()
timer:start(10 * 60 * 1000, 10 * 60 * 1000, vim.schedule_wrap(M.select_theme_by_time))

function M.next_theme()
  index = index + 1
  if index > #themes then
    index = 1
  end
  require('plugins.themes.' .. M.current_theme()).setup()
  if themes[index].transparent then
    require('utils').set_transparent_background()
  end
  vim.notify('Theme: ' .. M.current_theme(), vim.log.levels.INFO)
end

function M.prev_theme()
  index = index - 1
  if index < 1 then
    index = #themes
  end
  require('plugins.themes.' .. M.current_theme()).setup()
  if themes[index].transparent then
    require('utils').set_transparent_background()
  end
  vim.notify('Theme: ' .. M.current_theme(), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ThemeNext', M.next_theme, {})
vim.api.nvim_create_user_command('ThemePrev', M.prev_theme, {})

return M
