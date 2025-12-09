return {
  'stevearc/quicker.nvim',
  cond = not vim.g.vscode,
  config = function()
    ---@module "quicker"
    ---@type quicker.SetupOptions
    local opts = {
      keys = {
        {
          "<Tab>",
          function()
            require("quicker").expand()
          end,
          desc = "Expand quickfix context",
        },
        {
          "<S-Tab>",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    }
    require('quicker').setup(opts)
  end
}
