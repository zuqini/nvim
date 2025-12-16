local event = 'FileType'
local pattern = 'python'
return {
  {
    "nvim-lua/plenary.nvim",
    -- only needed for none-ls
    event = event,
    pattern = pattern,
    priority = 1000,
  },
  {
    "nvimtools/none-ls.nvim",
    cond = not vim.g.vscode,
    event = event,
    pattern = pattern,
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
        },
      })
    end,
  }
}
