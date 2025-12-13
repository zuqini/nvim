return {
  "smjonas/inc-rename.nvim",
  event = "VeryLazy",
  cond = not vim.g.vscode,
  config = function()
    require("inc_rename").setup()
  end,
}
