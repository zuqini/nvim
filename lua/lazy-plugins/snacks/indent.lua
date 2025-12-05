local M = {}

vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#662121" })
vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#767621" })
vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#216631" })
vim.api.nvim_set_hl(0, "SnacksIndent4", { fg = "#325a5e" })
vim.api.nvim_set_hl(0, "SnacksIndent5", { fg = "#324b7b" })
vim.api.nvim_set_hl(0, "SnacksIndent6", { fg = "#562155" })
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#00FF00" })

M.opts = {
  indent = {
    hl = {
      "SnacksIndent1",
      "SnacksIndent2",
      "SnacksIndent3",
      "SnacksIndent4",
      "SnacksIndent5",
      "SnacksIndent6",
    },
  },
}

return M
