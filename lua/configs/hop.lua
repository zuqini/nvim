local map = vim.api.nvim_set_keymap

require'hop'.setup{
    char2_fallback_key = '<cr>',
}

map("x", "s", "<cmd>HopChar2<cr>", { silent = true })
map("v", "s", "<cmd>HopChar2<cr>", { silent = true })
map("n", "s", "<cmd>HopChar2<cr>", { silent = true })

map("x", "<leader>/", "<cmd>HopPattern<cr>", { silent = true, noremap = true })
map("v", "<leader>/", "<cmd>HopPattern<cr>", { silent = true, noremap = true })
map("n", "<leader>/", "<cmd>HopPattern<cr>", { silent = true, noremap = true })
