-- disable nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- detect if is windows
vim.g.is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1

vim.g.search_with_fzf_lua = true
vim.g.search_with_fzf_vim = false
vim.g.search_with_telescope = not vim.g.search_with_fzf_lua

vim.g.transparent_background = true

_G.clear_floats_and_highlights = function ()
    vim.cmd[[ nohlsearch ]]
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
