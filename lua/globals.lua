vim.g.is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1

-- Both non-blink engines are built out of nvim's own machinery; they differ in
-- which. 'native-lsp-process' serves snippets, buffer words and paths from an
-- in-process LSP server so vim.lsp.completion merges them with the real ones.
-- 'native-autocomplete' serves the same candidates as 'complete' functions under
-- 'autocomplete', where each source anchors independently.
-- The env override is what makes the A/B cheap: NVIM_CMP_ENGINE=native-lsp-process
-- nvim in one split, plain nvim in another.
vim.g.cmp_engine = vim.env.NVIM_CMP_ENGINE or 'native-autocomplete' -- blink | native-lsp-process | native-autocomplete
vim.g.ui_engine = 'ui2'      -- ui2 | noice
vim.g.hybrid_nu = true
vim.g.transparent_background = true
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
