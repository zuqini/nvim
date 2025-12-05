return {
  "smjonas/inc-rename.nvim",
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  config = function()
    require("inc_rename").setup()
  end,
}
