return {
  "smjonas/inc-rename.nvim",
  cond = not vim.g.vscode,
  config = function()
    require("inc_rename").setup()
  end,
}
