local ft = 'python'
return {
  {
    "nvim-lua/plenary.nvim",
    -- only needed for none-ls
    ft = ft,
    priority = 1000,
  },
  {
    "nvimtools/none-ls.nvim",
    cond = not vim.g.vscode,
    ft = ft,
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
