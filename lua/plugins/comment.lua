return {
  "folke/ts-comments.nvim",
  enabled = vim.fn.has("nvim-0.10.0") == 1,
  config = function()
    require('ts-comments').setup({})
  end
}
