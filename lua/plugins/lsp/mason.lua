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

local opts = { noremap=true }
vim.api.nvim_set_keymap('n', '<leader>nt', ":LspRestart<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>ns', ":LspStop<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>nS', ":LspStart<CR>", opts)

require('which-key').register({
  n = {
    t = 'LspRestart',
    s = 'LspStop',
    S = 'LspStart',
  }
}, { prefix='<leader>' })
