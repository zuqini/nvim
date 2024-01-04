require'fzf-lua'.setup {
    winopts = {
        height = 0.90,
        width = 0.85,
        preview = {
            layout = 'vertical',
            vertical = 'down:75%',
        },
    },
    fzf_opts = {
        ['--layout'] = 'default',
        ['--keep-right'] = '',
    },
    fzf_colors = {
        ["fg"]          = { "fg", "CursorLine" },
        ["bg"]          = { "bg", "Normal" },
        ["hl"]          = { "fg", "Comment" },
        ["fg+"]         = { "fg", "Normal" },
        ["bg+"]         = { "bg", "CursorLine" },
        ["hl+"]         = { "fg", "Statement" },
        ["info"]        = { "fg", "PreProc" },
        ["prompt"]      = { "fg", "Conditional" },
        ["pointer"]     = { "fg", "Exception" },
        ["marker"]      = { "fg", "Keyword" },
        ["spinner"]     = { "fg", "Label" },
        ["header"]      = { "fg", "Comment" },
        ["gutter"]      = { "bg", "Normal" },
    }
}

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', 'S', ":lua require'fzf-lua'.files()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>s', ":lua require'fzf-lua'.grep({ search = ''})<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>S', ":lua require'fzf-lua'.live_grep_native()<CR>", opts)

vim.api.nvim_set_keymap('n', '<leader>o', ":lua require'fzf-lua'.oldfiles()<CR>", opts)

vim.api.nvim_set_keymap('n', '<leader>gf', ":lua require'fzf-lua'.git_files()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gs', ":lua require'fzf-lua'.git_status()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gc', ":lua require'fzf-lua'.git_commits()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gx', ":lua require'fzf-lua'.git_bcommits()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gb', ":lua require'fzf-lua'.git_branches()<CR>", opts)

vim.api.nvim_set_keymap('n', '<leader>t', ":lua require'fzf-lua'.tabs()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>b', ":lua require'fzf-lua'.buffers()<CR>", opts)

vim.api.nvim_set_keymap('n', '<leader>fq', ":lua require'fzf-lua'.quickfix()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>fQ', ":lua require'fzf-lua'.loclist()<CR>", opts)

vim.api.nvim_set_keymap('n', '<leader>lr', ":lua require'fzf-lua'.lsp_references()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>ld', ":lua require'fzf-lua'.lsp_definitions()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>lD', ":lua require'fzf-lua'.lsp_declarations()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>lt', ":lua require'fzf-lua'.lsp_typedefs()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>li', ":lua require'fzf-lua'.lsp_implementations()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>lc', ":lua require'fzf-lua'.lsp_code_actions()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>lsd', ":lua require'fzf-lua'.lsp_document_symbols()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>lsw', ":lua require'fzf-lua'.lsp_workspace_symbols()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>lsW', ":lua require'fzf-lua'.lsp_live_workspace_symbols()<CR>", opts)

vim.api.nvim_set_keymap('n', '<leader>lg', ":lua require'fzf-lua'.lsp_document_diagnostics()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>lG', ":lua require'fzf-lua'.lsp_workspace_diagnostics()<CR>", opts)
