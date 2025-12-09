return {
  { "kevinhwang91/promise-async" },
  {
    "kevinhwang91/nvim-fundo",
    cond = not vim.g.vscode,
    build = function() require("fundo").install() end,
    config = function()
      vim.o.undofile = true
      require('fundo').setup()
    end,
  }
}
