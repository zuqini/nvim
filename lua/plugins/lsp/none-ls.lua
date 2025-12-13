-- { "nvim-lua/plenary.nvim" },
return {
  "nvimtools/none-ls.nvim",
  cond = not vim.g.vscode,
  event = 'FileType',
  pattern = 'python',
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.black,
      },
    })
  end,
}
