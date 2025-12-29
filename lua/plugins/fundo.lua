return {
  { "kevinhwang91/promise-async" },
  {
    "kevinhwang91/nvim-fundo",
    cond = not vim.g.vscode,
    build = function() require("fundo").install() end,
    opts = {},
    config = function(_, opts)
      vim.o.undofile = true
      require('fundo').setup(opts)
    end,
  }
}
