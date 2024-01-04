-- '  ﳟ          ﲵ    ﴫ  '
local themes = {
  { name = 'nightfox', lualine = 'auto', tabby_header = ' 木 ' },
  { name = 'gruvbox', lualine = 'auto', tabby_header = ' 火 ' },
  { name = 'kanagawa', lualine = 'auto', tabby_header = ' 水 ' },
  { name = 'ayu', lualine = 'ayu', tabby_header = ' 土 ' },
}
local theme_index = 1
local theme_timer_active = 0

local timer = vim.loop.new_timer()
local min = 60 * 1000

local M = {}

function M.get_current_theme()
  return themes[theme_index].name
end

function M.get_current_lualine_theme()
  return themes[theme_index].lualine
end

function M.get_current_tabby_header()
  return themes[theme_index].tabby_header
end

function M.get_theme_index_by_time()
  local hour = tonumber(os.date("%H"))
  local index = 2
  if hour >= 8 and hour < 14 then
    -- morning
    index = 1
  elseif hour >= 14 and hour < 20 then
    -- dusk
    index = 2
  elseif hour >= 20 or hour < 2 then
    -- night
    index = 3
  elseif hour >= 2 and hour < 8 then
    -- dawn
    index = 4
  end
  return index
end

function M.select_theme_by_index(index)
  -- this disables lualine and stops its timers
  require('lualine').hide()

  -- experimental code for hot reloading
  -- hacky and buggy: unload theme packages for hot-reloading
  for package_name, _ in pairs(package.loaded) do
    for _, theme in pairs(themes) do
      if package_name:match(theme.name) then
        package.loaded[package_name] = nil
      end
    end
    if package_name:match('indent_blankline') or
        package_name:match('indent%-blankline') or
        package_name:match('tabby') or
        package_name:match('lualine') then
      package.loaded[package_name] = nil
    end
  end

  theme_index = index
  require('plugins.themes.' .. M.get_current_theme())
  require('plugins.indent-blankline.config')
  require('plugins.tabby.config')
  require('plugins.lualine.config')
end

function M.select_theme_by_time()
  local index = M.get_theme_index_by_time()
  if theme_index ~= index then
    M.select_theme_by_index(index)
  end
end

function M.clear_timer()
  if theme_timer_active == 1 then
    timer:close()
    theme_timer_active = 0
  end
end

function M.next()
  M.clear_timer()
  M.select_theme_by_index((theme_index % #themes) + 1)
end

function M.prev()
  M.clear_timer()
  M.select_theme_by_index(((theme_index - 2) % #themes) + 1)
end

-- experimental hot reloading
-- check every 10 min
timer:start(10 * min, 10 * min, vim.schedule_wrap(M.select_theme_by_time))
theme_timer_active = 1

vim.api.nvim_create_user_command('ThemeNext', M.next, {})
vim.api.nvim_create_user_command('ThemePrev', M.prev, {})
vim.api.nvim_create_user_command('TN', M.next, {})
vim.api.nvim_create_user_command('TP', M.prev, {})

theme_index = M.get_theme_index_by_time()
require('plugins.themes.' .. M.get_current_theme())

return M
