require('mason').setup({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  automatic_installation = {
    exclude = {
      "rust_analyzer",
      "omnisharp",
      "omnisharp_mono",
      "jdtls",
      "astro",
    }
  }
})
