return {
  'ibhagwan/fzf-lua',
  enabled = vim.g.search_with_fzf_lua,
  event = 'VeryLazy', -- @TODO: replace with keys
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'junegunn/fzf',
      build = './install --bin',
    },
  },
  config = function()
    require 'fzf-lua'.setup {
      file_ignore_patterns = { 'node_modules/.*', '.*%.jpg', '.*%.png', '.*%.gif', '.*%.jpeg' },
      winopts = {
        height = 0.95,
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
        ["fg"]      = { "fg", "CursorLine" },
        ["bg"]      = { "bg", "Normal" },
        ["hl"]      = { "fg", "Comment" },
        ["fg+"]     = { "fg", "Normal" },
        ["bg+"]     = { "bg", "CursorLine" },
        ["hl+"]     = { "fg", "Statement" },
        ["info"]    = { "fg", "PreProc" },
        ["prompt"]  = { "fg", "Conditional" },
        ["pointer"] = { "fg", "Exception" },
        ["marker"]  = { "fg", "Keyword" },
        ["spinner"] = { "fg", "Label" },
        ["header"]  = { "fg", "Comment" },
        ["gutter"]  = { "bg", "Normal" },
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept", -- https://github.com/ibhagwan/fzf-lua/issues/324
        }
      }
    }

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap('n', 'S', ":lua require'fzf-lua'.files()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>s', ":lua require'fzf-lua'.grep({ search = ''})<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>S', ":lua require'fzf-lua'.live_grep_native()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>ns', ":lua require'fzf-lua'.files({ cmd = 'fd --no-ignore --hidden' })<CR>",
      opts)

    vim.api.nvim_set_keymap('n', '<leader>o', ":lua require'fzf-lua'.oldfiles()<CR>", opts)

    vim.api.nvim_set_keymap('n', '<leader>,f', ":lua require'fzf-lua'.git_files()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>,s', ":lua require'fzf-lua'.git_status()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>,c', ":lua require'fzf-lua'.git_commits()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>,x', ":lua require'fzf-lua'.git_bcommits()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>,b', ":lua require'fzf-lua'.git_branches()<CR>", opts)

    vim.api.nvim_set_keymap('n', '<leader>b', ":lua require'fzf-lua'.buffers()<CR>", opts)

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

    vim.api.nvim_set_keymap('n', '<leader>lq', ":lua require'fzf-lua'.quickfix()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>lQ', ":lua require'fzf-lua'.loclist()<CR>", opts)

    vim.api.nvim_set_keymap('n', '<leader>fc', ":lua require'fzf-lua'.commands()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>ff', ":lua require'fzf-lua'.resume()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>f;', ":lua require'fzf-lua'.command_history()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>f/', ":lua require'fzf-lua'.search_history()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fb', ":lua require'fzf-lua'.builtin()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fr', ":lua require'fzf-lua'.registers()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fp', ":lua require'fzf-lua'.spell_suggest()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fk', ":lua require'fzf-lua'.keymaps()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fh', ":lua require'fzf-lua'.help_tags()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fd', ":lua require'fzf-lua'.files({ cwd = '~/dotfiles' })<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>ft', ":lua require'fzf-lua'.tabs()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fm', ":lua require'fzf-lua'.marks()<CR>", opts)

    require('which-key').register({
      S = 'Find Files'
    })
    require('which-key').register({
      s = 'Grep',
      S = 'Native Grep',
      o = 'Old Files (History)',
      b = 'Buffers',
      [","] = {
        name = 'Fzf-Git',
        b = 'Branches',
        c = 'Commits',
        f = 'Files',
        s = 'Status',
        x = 'BCommits',
      },
      l = {
        name = 'Fzf-LSP',
        r = 'References',
        d = 'Definitions',
        D = 'Declarations',
        t = 'TypeDefs',
        i = 'Implementations',
        c = 'Code Actions',
        s = {
          name = 'Symbols',
          d = "Document Symbols",
          w = "Workspace Symbols",
          W = "Live Workspace Symbols",
        },
        g = 'Diagnostics',
        G = 'Workspace Diagnostics',
        q = 'Quickfix',
        Q = 'Loclist',
      },
      f = {
        name = 'Fzf-Misc',
        s = 'All Files (hidden, ignored)',
        c = 'Commands',
        u = 'Resume',
        [';'] = 'Commands History',
        ['/'] = 'Search History',
        b = 'Fzf Builtin',
        r = 'Registers',
        p = 'Spell Suggest',
        k = 'Keymaps',
        h = 'Help',
        d = 'Dotfiles',
        t = 'Tabs',
      },
    }, { prefix = '<leader>' })
  end
}
