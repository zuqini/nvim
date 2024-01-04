-- TODO: Instead of using vim variables, convert to full lua 
vim.g.themes = {
  'gruvbox',
  'kanagawa',
  'tokyonight',
  'spaceduck',
}
vim.g.theme_index = 3
vim.g.theme = vim.g.themes[vim.g.theme_index]
require('themes/' .. vim.g.theme)

local M = {}
function M.selectThemeByIndex(index)
  -- a bit hacky: unload theme packages for reloading
  for package_name, _ in pairs(package.loaded) do
    for _, theme_name in pairs(vim.g.themes) do
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
  if hour > 7 and hour < 16 then
    index = 2
  elseif hour >= 16 and hour < 21 then
    index = 3
  else
    index = 4
  end
  if vim.g.theme_index ~= index then
    M.selectThemeByIndex(index)
  end
end

vim.api.nvim_set_keymap('n', '<leader>m', ':lua require"themes/theme".cycleTheme()<CR>', {noremap = true, silent = true})

local timer = vim.loop.new_timer()
timer:start((60 - tonumber(os.date("%M"))) * 1000 * 60 + 1000 * 60, 60 * 60 * 1000, vim.schedule_wrap(M.selectThemeByTime))
M.selectThemeByTime()

return M
