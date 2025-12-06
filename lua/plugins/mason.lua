return {
  { "mason-org/mason.nvim" },
  {
    "mason-org/mason-lspconfig.nvim",
    cond = not vim.g.vscode,
    config = function()
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          "vimls",
          "lua_ls",
        },
        automatic_enable = {
          exclude = { "rust_analyzer" }
        }
      })
    end,
  },
}
