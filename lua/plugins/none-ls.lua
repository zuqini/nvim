return {
  {
    "nvimtools/none-ls.nvim",
    cond = not vim.g.vscode,
    ft = 'python',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('utils').schedule_notify('None-ls loaded on FileType python')
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
        },
      })
    end,
  }
}
