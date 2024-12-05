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
        builtin = {
          ["<Esc>"] = "hide",
        },
        fzf = {
          -- Send all current search results to QuickFix list
          ["ctrl-q"] = "select-all+accept", -- https://github.com/ibhagwan/fzf-lua/issues/324
        }
      }
    }
    local nmap = function(suffix, rhs, desc)
      vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc, noremap = true, silent = true })
    end

    nmap('ff', ":lua require'fzf-lua'.files()<CR>", 'Files')
    nmap('fs', ":lua require'fzf-lua'.files({ git_icons = false})<CR>", 'Files No Git Icons')
    nmap('fF', ":lua require'fzf-lua'.files({ git_icons = false, cmd = 'fd --no-ignore --hidden' })<CR>",
      'Files + Hidden')

    nmap('fn', ":lua require'fzf-lua'.grep_project()<CR>", 'FiNd')
    nmap('fh', ":lua require'fzf-lua'.grep({search = '', rg_opts = '--hidden', fzf_opts = { ['--nth'] = '2..' }})<CR>",
      'FiNd Hidden')
    nmap('fN', ":lua require'fzf-lua'.live_grep_native()<CR>", 'Find Native')

    nmap('fo', ":lua require'fzf-lua'.oldfiles()<CR>", 'Old Files')

    nmap(',f', ":lua require'fzf-lua'.git_files()<CR>", 'Git Files')
    nmap(',s', ":lua require'fzf-lua'.git_status()<CR>", 'Git Status')
    nmap(',c', ":lua require'fzf-lua'.git_commits()<CR>", 'Git Commits')
    nmap(',x', ":lua require'fzf-lua'.git_bcommits()<CR>", 'Git BCommits')
    nmap(',b', ":lua require'fzf-lua'.git_branches()<CR>", 'Git Branches')

    nmap('lr', ":lua require'fzf-lua'.lsp_references()<CR>", 'LSP Refs')
    nmap('ld', ":lua require'fzf-lua'.lsp_definitions()<CR>", 'LSP Defs')
    nmap('lD', ":lua require'fzf-lua'.lsp_declarations()<CR>", 'LSP Decl')
    nmap('lt', ":lua require'fzf-lua'.lsp_typedefs()<CR>", 'LSP TypeDefs')
    nmap('li', ":lua require'fzf-lua'.lsp_implementations()<CR>", 'LSP Impls')
    nmap('la', ":lua require'fzf-lua'.lsp_code_actions()<CR>", 'LSP Code Actions')
    nmap('lsd', ":lua require'fzf-lua'.lsp_document_symbols()<CR>", 'LSP Doc Symbols')
    nmap('lsw', ":lua require'fzf-lua'.lsp_workspace_symbols()<CR>", 'LSP Workspace Symbols')
    nmap('lsW', ":lua require'fzf-lua'.lsp_live_workspace_symbols()<CR>", 'LSP Live Workspace Symbols')
    nmap('lg', ":lua require'fzf-lua'.lsp_document_diagnostics()<CR>", 'LSP Doc Diagnostics')
    nmap('lG', ":lua require'fzf-lua'.lsp_workspace_diagnostics()<CR>", 'LSP Workspace Diagnostics')

    nmap('lc', ":lua require'fzf-lua'.quickfix()<CR>", 'QuickFix')
    nmap('lx', ":lua require'fzf-lua'.loclist()<CR>", 'LocList')

    nmap('fc', ":lua require'fzf-lua'.commands()<CR>", 'Commands')
    nmap('fe', ":lua require'fzf-lua'.resume()<CR>", 'REsume')
    nmap('f;', ":lua require'fzf-lua'.command_history()<CR>", 'Command History')
    nmap('f/', ":lua require'fzf-lua'.search_history()<CR>", 'Search History')
    nmap('fb', ":lua require'fzf-lua'.buffers()<CR>", 'Buffers')
    nmap('fi', ":lua require'fzf-lua'.builtin()<CR>", 'Builtin')
    nmap('fr', ":lua require'fzf-lua'.registers()<CR>", 'Registers')
    nmap('fp', ":lua require'fzf-lua'.spell_suggest()<CR>", 'Spell Suggs')
    nmap('fk', ":lua require'fzf-lua'.keymaps()<CR>", 'Keymaps')
    nmap('fH', ":lua require'fzf-lua'.help_tags()<CR>", 'Help Tags')
    nmap('fd', ":lua require'fzf-lua'.files({ cwd = '~/dotfiles' })<CR>", 'Dot Files')
    nmap('ft', ":lua require'fzf-lua'.tabs()<CR>", 'Tabs')
    nmap('fm', ":lua require'fzf-lua'.marks()<CR>", 'Marks')
  end
}
