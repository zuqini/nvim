local map = vim.api.nvim_set_keymap

require('hop').setup()
map("x", "s", "<cmd>HopChar2<cr>", { silent = true })
map("v", "s", "<cmd>HopChar2<cr>", { silent = true })
map("n", "s", "<cmd>HopChar2<cr>", { silent = true })

map("x", "<leader>f", "<cmd>HopChar1<cr>", { silent = true })
map("v", "<leader>f", "<cmd>HopChar1<cr>", { silent = true })
map("n", "<leader>f", "<cmd>HopChar1<cr>", { silent = true })

map("x", "<leader>w", "<cmd>HopWord<cr>", { silent = true })
map("v", "<leader>w", "<cmd>HopWord<cr>", { silent = true })
map("n", "<leader>w", "<cmd>HopWord<cr>", { silent = true })

map("x", "<leader>/", "<cmd>HopPattern<cr>", { silent = true })
map("v", "<leader>/", "<cmd>HopPattern<cr>", { silent = true })
map("n", "<leader>/", "<cmd>HopPattern<cr>", { silent = true })
