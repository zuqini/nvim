-- TODO: Instead of using vim variables, convert to full lua 
vim.g.themes = {
  'nightfox',
  'gruvbox',
  'kanagawa',
  'tokyonight',
  'spaceduck',
}
vim.g.theme_index = 1
vim.g.theme = vim.g.themes[vim.g.theme_index]
vim.g.theme_timer_active = 1
require('themes/' .. vim.g.theme)

local timer = vim.loop.new_timer()
local min = 60 * 1000;

local M = {}
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
        package_name:match('lualine') then
      package.loaded[package_name] = nil
    end
  end

  vim.g.theme_index = index
  vim.g.theme = vim.g.themes[vim.g.theme_index]
  require('themes/' .. vim.g.theme)
  require('plugins/indent_blankline')
  require('plugins/lualine')
end

function M.selectThemeByTime()
  local hour = tonumber(os.date("%H"))
  local index = 2
  if hour > 7 and hour < 19 then
    index = 1
  else
    index = 2
  end
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

vim.api.nvim_create_user_command('ThemeNext', M.next, {})
vim.api.nvim_create_user_command('ThemePrev', M.prev, {})
vim.api.nvim_create_user_command('TN', M.next, {})
vim.api.nvim_create_user_command('TP', M.prev, {})

M.selectThemeByTime()

return M
