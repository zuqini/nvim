return {
  "kevinhwang91/nvim-fundo",
  cond = not vim.g.vscode,
  dependencies = {
    "kevinhwang91/promise-async",
  },
  build = function() require("fundo").install() end,
  lazy = false,
  config = function()
    vim.o.undofile = true
    require('fundo').setup()
  end,
}
