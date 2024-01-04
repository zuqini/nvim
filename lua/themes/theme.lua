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
require('themes/' .. vim.g.theme)

local M = {}
function M.selectThemeByIndex(index)
  -- a bit hacky: unload theme packages for reloading
  for _, theme_name in pairs(vim.g.themes) do
    for package_name, _ in pairs(package.loaded) do
      if package_name:match(theme_name) then
        package.loaded[package_name] = nil
      end
    end
  end

  vim.g.theme_index = index
  vim.g.theme = vim.g.themes[vim.g.theme_index]
  require('themes/' .. vim.g.theme)
end

function M.cycleTheme()
  M.selectThemeByIndex((vim.g.theme_index % #vim.g.themes) + 1)
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

vim.api.nvim_set_keymap('n', '<leader>m', ':lua require"themes/theme".cycleTheme()<CR>', {noremap = true, silent = true})

local timer = vim.loop.new_timer()
local min = 60 * 1000;
-- check every 10 min
timer:start(10 * min, 10 * min, vim.schedule_wrap(M.selectThemeByTime))
M.selectThemeByTime()

return M
