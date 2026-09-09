return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    cond = not vim.g.vscode,
    config = function()
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          "vimls",
          "lua_ls",
        },
        -- jdtls is enabled by nvim-jdtls, which loads on ft=java. Enabling it
        -- here would resolve the config before nvim-jdtls is on the rtp, losing
        -- its extended client capabilities.
        automatic_enable = {
          exclude = { "rust_analyzer", "jdtls" }
        }
      })
    end,
  },
}
