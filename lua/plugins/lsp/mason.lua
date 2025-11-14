return {
  "mason-org/mason-lspconfig.nvim",
  cond = not vim.g.vscode,
  opts = {
    ensure_installed = {
      "vimls",
      "lua_ls",
    },
    automatic_enable = {
      exclude = { "rust_analyzer" }
    }
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
