-- TODO: Instead of using vim variables, convert to full lua 
vim.g.themes = {
  'gruvbox',
  'kanagawa',
  'tokyonight',
  'spaceduck',
}
vim.g.theme_index = 2
vim.g.theme = vim.g.themes[vim.g.theme_index]
require('themes/' .. vim.g.theme)

local M = {}
function M.cycleTheme()
  -- a bit hacky: unload theme packages for reloading
  for package_name, _ in pairs(package.loaded) do
    for _, theme_name in pairs(vim.g.themes) do
      if package_name:match(theme_name) then
        package.loaded[package_name] = nil
      end
    end
  end

  vim.g.theme_index = (vim.g.theme_index % #vim.g.themes) + 1
  vim.g.theme = vim.g.themes[vim.g.theme_index]
  require('themes/' .. vim.g.theme)
end

vim.api.nvim_set_keymap('n', '<leader>m', ':lua require"themes/theme".cycleTheme()<CR>', {noremap = true, silent = true})
return M
