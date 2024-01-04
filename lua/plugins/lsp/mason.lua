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
  automatic_installation = { exclude = { "rust_analyzer", "omnisharp", "omnisharp_mono" } }
})

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>rt', ":LspRestart<CR>", opts)
