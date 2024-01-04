-- TODO: Instead of using vim variables, convert to full lua 
vim.g.themes = {
  'nightfox',
  'gruvbox',
  'kanagawa',
  'tokyonight',
}
vim.g.theme_index = 1
vim.g.theme = vim.g.themes[vim.g.theme_index]
vim.g.theme_timer_active = 0

local timer = vim.loop.new_timer()
local min = 60 * 1000

vim.cmd [[
]]

local M = {}

function M.getThemeIndexByTime()
  local hour = tonumber(os.date("%H"))
  local index = 2
  if hour >= 9 and hour < 15 then
    -- morning
    index = 1
  elseif hour >= 15 and hour < 21 then
    -- dusk
    index = 2
  elseif hour >= 21 or hour < 3 then
    -- night
    index = 3
  else
    -- dawn
    index = 4
  end
  return index
end

function M.selectThemeByIndex(index)
  -- this disables lualine and stops its timers
  require('lualine').hide()

  -- experimental code for hot reloading
  -- hacky and buggy: unload theme packages for hot-reloading
  for package_name, _ in pairs(package.loaded) do
    for _, theme_name in pairs(vim.g.themes) do
      if package_name:match(theme_name) then
        package.loaded[package_name] = nil
      end
    end
    if package_name:match('indent_blankline') or
        package_name:match('indent%-blankline') or
        package_name:match('lualine') then
      package.loaded[package_name] = nil
    end
  end

  vim.g.theme_index = index
  vim.g.theme = vim.g.themes[vim.g.theme_index]
  require('plugins.themes.' .. vim.g.theme)
  require('plugins.indent-blankline.config')
  require('plugins.lualine.config')
end

function M.selectThemeByTime()
  local index = M.getThemeIndexByTime()
  if vim.g.theme_index ~= index then
    M.selectThemeByIndex(index)
  end
end

function M.clearTimer()
  if vim.g.theme_timer_active == 1 then
    timer:close()
    vim.g.theme_timer_active = 0
  end
end

function M.next()
  M.clearTimer()
  M.selectThemeByIndex((vim.g.theme_index % #vim.g.themes) + 1)
end

function M.prev()
  M.clearTimer()
  M.selectThemeByIndex(((vim.g.theme_index - 2) % #vim.g.themes) + 1)
end

-- experimental hot reloading
-- check every 10 min
timer:start(10 * min, 10 * min, vim.schedule_wrap(M.selectThemeByTime))
vim.g.theme_timer_active = 1

vim.api.nvim_create_user_command('ThemeNext', M.next, {})
vim.api.nvim_create_user_command('ThemePrev', M.prev, {})
vim.api.nvim_create_user_command('TN', M.next, {})
vim.api.nvim_create_user_command('TP', M.prev, {})

vim.g.theme_index = M.getThemeIndexByTime()
vim.g.theme = vim.g.themes[vim.g.theme_index]
require('plugins.themes.' .. vim.g.theme)

return M
