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
vim.api.nvim_set_keymap('n', '<leader>gt', ":LspRestart<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gs', ":LspStop<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gS', ":LspStart<CR>", opts)

require('which-key').register({
  g = {
    name = 'Lang.',
    t = 'LspRestart',
    s = 'LspStop',
    S = 'LspStart',
  }
}, { prefix='<leader>' })
