require("citruszest").setup({
  style = {
    CursorLine = { bg = "#222222" }
  },
})
vim.cmd("colorscheme citruszest")
vim.api.nvim_set_hl(0, 'Cursor', { reverse=true })
vim.api.nvim_set_hl(0, 'TermCursor', { reverse=true })
vim.api.nvim_set_hl(0, 'TermCursorNC', { reverse=true })
