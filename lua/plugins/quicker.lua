return {
  'stevearc/quicker.nvim',
  cond = not vim.g.vscode,
  ft = 'qf',
  ---@type quicker.SetupOptions
  opts = {
    keys = {
      { "<Tab>", function() require("quicker").expand() end, desc = "Expand quickfix context" },
      { "<S-Tab>", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
    },
  },
}
