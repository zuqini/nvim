vim.g.is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1

vim.g.cmp_engine = 'blink'
vim.g.hybrid_nu = true
vim.g.transparent_background = true
vim.g.winblend = 10
vim.g.no_winblend_if_transparent = false
vim.g.transparent_float_if_transparent = false
vim.g.virtual_line_current_line = true

_G.clear_floats_and_highlights = function()
  vim.cmd [[ nohlsearch ]]
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local success, config = pcall(vim.api.nvim_win_get_config, win)
    if not success then
      return
    end

    if config.relative ~= "" then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end
end
