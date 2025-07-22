return {
  "mason-org/mason-lspconfig.nvim",
  cond = not vim.g.vscode,
  opts = {
    automatic_enable = {
      ensure_installed = {
        "vimls",
        "lua_ls",
      },
      exclude = { "rust_analyzer" }
    }
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
