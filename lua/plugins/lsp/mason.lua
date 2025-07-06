return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = {
        exclude = {
          "rust_analyzer",
          "omnisharp",
          "omnisharp_mono",
          "jdtls",
          "astro",
        }
      }
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
