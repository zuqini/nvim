-- '  ﳟ          ﲵ    ﴫ  '
local themes = {
  { name = 'gruvbox',   lualine = 'auto' },
  { name = 'terafox',   alt_name = 'nightfox', lualine = 'auto' },
  { name = 'duskfox',   alt_name = 'nightfox', lualine = 'auto' },
  { name = 'nightfox',  alt_name = 'nightfox', lualine = 'auto' },
  { name = 'carbonfox', alt_name = 'nightfox', lualine = 'auto' },
}
local theme_index = 1
local theme_timer_active = 0

Timer = vim.uv.new_timer()
local min = 60 * 1000

local M = {}

function M.get_current_theme()
  return themes[theme_index].name
end

function M.get_current_lualine_theme()
  return themes[theme_index].lualine
end

function M.get_theme_index_by_time()
  local hour = tonumber(os.date("%H"))
  local index = 2
  if hour >= 6 and hour < 11 then
    -- morning
    index = 1
  elseif hour >= 11 and hour < 17 then
    -- day
    index = 2
  elseif hour >= 17 and hour < 21 then
    -- dusk
    index = 3
  elseif hour >= 21 or hour < 1 then
    -- early night
    index = 4
  elseif hour >= 1 and hour < 6 then
    -- Deep night
    index = 5
  end
  return index
end

function M.select_theme_by_index(index)
  -- this disables lualine and stops its timers
  require('lualine').hide({})

  -- experimental code for hot reloading
  -- hacky and buggy: unload theme packages for hot-reloading
  local ibl_loaded = false
  for package_name, _ in pairs(package.loaded) do
    for _, theme in pairs(themes) do
      if package_name:match(theme.name) or
          (theme['alt_name'] ~= nil and package_name:match(theme.alt_name)) then
        package.loaded[package_name] = nil
      end
    end
    if package_name:match('indent_blankline')
        or package_name:match('indent%-blankline')
        or package_name:match('ibl')
    then
      ibl_loaded = true
      package.loaded[package_name] = nil
    end
    if package_name:match('lualine')
        or package_name:match('noice')
    then
      package.loaded[package_name] = nil
    end
  end

  theme_index = index
  require('plugins.themes.' .. M.get_current_theme())
  if ibl_loaded then
    require('plugins.config.ibl')
  end
  require('plugins.config.lualine')
  require('plugins.config.noice')
  if vim.g.transparent_background then
    vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
    vim.cmd('hi NormalNC guibg=NONE ctermbg=NONE')
    vim.cmd('hi Terminal guibg=NONE ctermbg=NONE')
    vim.cmd('hi SignColumn guibg=NONE ctermbg=NONE')

    vim.cmd('hi TelescopeBorder guibg=NONE ctermbg=NONE')
    vim.cmd('hi TelescopePromptNormal guibg=NONE ctermbg=NONE')
    vim.cmd('hi TelescopePreviewNormal guibg=NONE ctermbg=NONE')
    vim.cmd('hi TelescopeResultsNormal guibg=NONE ctermbg=NONE')

    if vim.g.colors_name ~= "gruvbox-material" then
      vim.cmd('hi DiagnosticVirtualTextError guibg=NONE ctermbg=NONE')
      vim.cmd('hi DiagnosticVirtualTextWarn guibg=NONE ctermbg=NONE')
      vim.cmd('hi DiagnosticVirtualTextInfo guibg=NONE ctermbg=NONE')
      vim.cmd('hi DiagnosticVirtualTextHint guibg=NONE ctermbg=NONE')
      vim.cmd('hi DiagnosticVirtualTextOk guibg=NONE ctermbg=NONE')
    end
  end
end

function M.select_theme_by_time()
  local index = M.get_theme_index_by_time()
  if theme_index ~= index then
    M.select_theme_by_index(index)
  end
end

function M.clear_timer()
  if theme_timer_active == 1 then
    Timer:close()
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
Timer:start(10 * min, 10 * min, vim.schedule_wrap(M.select_theme_by_time))
theme_timer_active = 1

vim.api.nvim_create_user_command('ThemeNext', M.next, {})
vim.api.nvim_create_user_command('ThemePrev', M.prev, {})
vim.api.nvim_create_user_command('TN', M.next, {})
vim.api.nvim_create_user_command('TP', M.prev, {})

theme_index = M.get_theme_index_by_time()
require('plugins.themes.' .. M.get_current_theme())

return M
