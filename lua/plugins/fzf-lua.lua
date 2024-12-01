return {
  'ibhagwan/fzf-lua',
  enabled = vim.g.fuzzy_search_plugin == 'fzf-lua',
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
      -- this seems to be super slow,
      -- try this instead: https://github.com/ibhagwan/fzf-lua/wiki#how-do-i-exclude-paths-eg-node_modules
      -- file_ignore_patterns = {
      --   'node_modules/.*',
      --   '.godot/.*',
      --   '.eslintcache',
      --   'tags',
      --   '.*%.tscn',
      --   -- images
      --   '.*%.svg.*',
      --   '.*%.jpg.*',
      --   '.*%.png.*',
      --   '.*%.gif.*',
      --   '.*%.jpeg.*',
      --   -- audio
      --   '.*%.mp3.*',
      --   '.*%.ogg.*',
      --   '.*%.wav.*',
      -- },
      winopts = {
        height = 0.95,
        width = 0.85,
        preview = {
          -- investigate https://github.com/ibhagwan/fzf-lua/issues/1002
          layout = 'vertical',
          vertical = 'down:55%',
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
          -- Send all current search results to QuickFix list
          ["ctrl-q"] = "select-all+accept", -- https://github.com/ibhagwan/fzf-lua/issues/324
        }
      }
    }

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap('n', '<leader>ff', ":lua require'fzf-lua'.files()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fs', ":lua require'fzf-lua'.files({ git_icons = false})<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fF', ":lua require'fzf-lua'.files({ git_icons = false, cmd = 'fd --no-ignore --hidden' })<CR>", opts)

    vim.api.nvim_set_keymap('n', '<leader>fn', ":lua require'fzf-lua'.grep_project()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fh', ":lua require'fzf-lua'.grep({search = '', rg_opts = '--hidden', fzf_opts = { ['--nth'] = '2..' }})<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fN', ":lua require'fzf-lua'.live_grep_native()<CR>", opts)

    vim.api.nvim_set_keymap('n', '<leader>fo', ":lua require'fzf-lua'.oldfiles()<CR>", opts)

    vim.api.nvim_set_keymap('n', '<leader>,s', ":lua require'fzf-lua'.git_files()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>,t', ":lua require'fzf-lua'.git_status()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>,c', ":lua require'fzf-lua'.git_commits()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>,x', ":lua require'fzf-lua'.git_bcommits()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>,b', ":lua require'fzf-lua'.git_branches()<CR>", opts)


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
    vim.api.nvim_set_keymap('n', '<leader>fe', ":lua require'fzf-lua'.resume()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>f;', ":lua require'fzf-lua'.command_history()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>f/', ":lua require'fzf-lua'.search_history()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fb', ":lua require'fzf-lua'.buffers()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fi', ":lua require'fzf-lua'.builtin()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fr', ":lua require'fzf-lua'.registers()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fp', ":lua require'fzf-lua'.spell_suggest()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fk', ":lua require'fzf-lua'.keymaps()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fH', ":lua require'fzf-lua'.help_tags()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fd', ":lua require'fzf-lua'.files({ cwd = '~/dotfiles' })<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>ft', ":lua require'fzf-lua'.tabs()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>fm', ":lua require'fzf-lua'.marks()<CR>", opts)

    require('which-key').add({

      { "<leader>,", group = "Fzf-Git" },
      { "<leader>,b", desc = "Branches" },
      { "<leader>,c", desc = "Commits" },
      { "<leader>,s", desc = "Files" },
      { "<leader>,t", desc = "Status" },
      { "<leader>,x", desc = "BCommits" },

      { "<leader>ff", desc = "Find Files" },
      { "<leader>fs", desc = "Find Files (no git-icons)" },
      { "<leader>fF", desc = "Find Files (no git-icons, hidden, ignored)" },

      { "<leader>fo", desc = "Old Files (History)" },
      { "<leader>fn", desc = "Grep" },
      { "<leader>fN", desc = "Native Grep" },
      { "<leader>fh", desc = "Grep (hidden)" },

      { "<leader>f", group = "Fzf-Misc" },
      { "<leader>f/", desc = "Search History" },
      { "<leader>f;", desc = "Commands History" },
      { "<leader>fb", desc = "Fzf Buffers" },
      { "<leader>fi", desc = "Fzf Builtin" },
      { "<leader>fc", desc = "Commands" },
      { "<leader>fd", desc = "Dotfiles" },
      { "<leader>fe", desc = "Resume" },
      { "<leader>fH", desc = "Help" },
      { "<leader>fk", desc = "Keymaps" },
      { "<leader>fp", desc = "Spell Suggest" },
      { "<leader>fr", desc = "Registers" },
      { "<leader>ft", desc = "Tabs" },

      { "<leader>l", group = "Fzf-LSP" },
      { "<leader>lD", desc = "Declarations" },
      { "<leader>lG", desc = "Workspace Diagnostics" },
      { "<leader>lQ", desc = "Loclist" },
      { "<leader>lc", desc = "Code Actions" },
      { "<leader>ld", desc = "Definitions" },
      { "<leader>lg", desc = "Diagnostics" },
      { "<leader>li", desc = "Implementations" },
      { "<leader>lq", desc = "Quickfix" },
      { "<leader>lr", desc = "References" },
      { "<leader>ls", group = "Symbols" },
      { "<leader>lsW", desc = "Live Workspace Symbols" },
      { "<leader>lsd", desc = "Document Symbols" },
      { "<leader>lsw", desc = "Workspace Symbols" },
      { "<leader>lt", desc = "TypeDefs" },
    })
  end
}
