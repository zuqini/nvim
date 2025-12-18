return {
  "folke/lazydev.nvim",
  cond = not vim.g.vscode,
  event = { event = "BufReadPre", pattern = "*.lua" },
  config = function()
    require('utils').schedule_notify('Lazydev loaded on BufReadPre lua')
    require('lazydev').setup({
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim",        words = { "Snacks" } },
      },
    })
  end,
}
