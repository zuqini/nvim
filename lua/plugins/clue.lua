return {
  {
    'echasnovski/mini.clue',
    version = false,
    config = function()
      local miniclue = require('mini.clue')
      miniclue.setup({
        window = {
          delay = 0,
        },
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },
        },

        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end
  },
        -- { "<leader>C",  desc = "Clipboard Y" },
        -- { "<leader>P",  desc = "Last Yanked P" },
        -- { "<leader>R",  desc = "Read :cmd" },
        -- { "<leader>V",  desc = "Clipboard P" },
        -- { "<leader>W",  desc = "Save & Quit" },
        -- { "<leader>X",  desc = "Clipboard D" },
        -- { "<leader>Y",  desc = "Clipboard Y" },
        -- { "<leader>c",  desc = "Clipboard y" },
        -- { "<leader>gH", desc = "Open GH repo" },
        -- { "<leader>gh", desc = "Open GH file" },
        -- { "<leader>j",  desc = "Quickfix Next" },
        -- { "<leader>k",  desc = "Quickfix Prev" },
        -- { "<leader>p",  desc = "Last Yanked p" },
        -- { "<leader>u",  desc = "UndoTree" },
        -- { "<leader>v",  desc = "Clipboard p" },
        -- { "<leader>w",  desc = "Save" },
        -- { "<leader>x",  desc = "Clipboard d" },
        -- { "<leader>y",  desc = "Clipboard y" },
        -- { "<leader>z",  desc = "Auto Center" },
        --
      -- { "<leader>,", group = "Fzf-Git" },
      -- { "<leader>,b", desc = "Branches" },
      -- { "<leader>,c", desc = "Commits" },
      -- { "<leader>,s", desc = "Files" },
      -- { "<leader>,t", desc = "Status" },
      -- { "<leader>,x", desc = "BCommits" },
      --
      -- { "<leader>ff", desc = "Find Files" },
      -- { "<leader>fs", desc = "Find Files (no git-icons)" },
      -- { "<leader>fF", desc = "Find Files (no git-icons, hidden, ignored)" },
      --
      -- { "<leader>fo", desc = "Old Files (History)" },
      -- { "<leader>fn", desc = "Grep" },
      -- { "<leader>fN", desc = "Native Grep" },
      -- { "<leader>fh", desc = "Grep (hidden)" },
      --
      -- { "<leader>f", group = "Fzf-Misc" },
      -- { "<leader>f/", desc = "Search History" },
      -- { "<leader>f;", desc = "Commands History" },
      -- { "<leader>fb", desc = "Fzf Buffers" },
      -- { "<leader>fi", desc = "Fzf Builtin" },
      -- { "<leader>fc", desc = "Commands" },
      -- { "<leader>fd", desc = "Dotfiles" },
      -- { "<leader>fe", desc = "Resume" },
      -- { "<leader>fH", desc = "Help" },
      -- { "<leader>fk", desc = "Keymaps" },
      -- { "<leader>fp", desc = "Spell Suggest" },
      -- { "<leader>fr", desc = "Registers" },
      -- { "<leader>ft", desc = "Tabs" },
      --
      -- { "<leader>l", group = "Fzf-LSP" },
      -- { "<leader>lD", desc = "Declarations" },
      -- { "<leader>lG", desc = "Workspace Diagnostics" },
      -- { "<leader>lQ", desc = "Loclist" },
      -- { "<leader>lc", desc = "Code Actions" },
      -- { "<leader>ld", desc = "Definitions" },
      -- { "<leader>lg", desc = "Diagnostics" },
      -- { "<leader>li", desc = "Implementations" },
      -- { "<leader>lq", desc = "Quickfix" },
      -- { "<leader>lr", desc = "References" },
      -- { "<leader>ls", group = "Symbols" },
      -- { "<leader>lsW", desc = "Live Workspace Symbols" },
      -- { "<leader>lsd", desc = "Document Symbols" },
      -- { "<leader>lsw", desc = "Workspace Symbols" },
      -- { "<leader>lt", desc = "TypeDefs" },

      -- { "[g", desc = "Prev Hunk" },
      -- { "]g", desc = "Next Hunk" },
      -- { "<leader>;", group = "GitSigns" },
      -- { "<leader>;R", desc = "Reset Buffer" },
      -- { "<leader>;S", desc = "Stage Buffer" },
      -- { "<leader>;b", desc = "Blame" },
      -- { "<leader>;d", desc = "Diff" },
      -- { "<leader>;p", desc = "Preview Hunk" },
      -- { "<leader>;r", desc = "Reset Hunk" },
      -- { "<leader>;s", desc = "Stage Hunk" },
      -- { "<leader>;t", group = "Toggle" },
      -- { "<leader>;tb", desc = "Blame" },
      -- { "<leader>;td", desc = "Deleted" },
      -- { "<leader>;u", desc = "Undo Stage Hunk" },

  -- { "grr",       desc = "References" },
  -- { "grn",       desc = "Rename" },
  -- { "gra",       desc = "Code Action" },
  -- { "<leader>e", desc = "Open Float" },

    -- { "K",          desc = "Hover" },
    -- { "g",          group = "LSP." },
    -- { "gD",         desc = "Declaration" },
    -- { "gR",         desc = "References (incl. decl)" },
    -- { "gd",         desc = "Definition" },
    -- { "gi",         desc = "Implementation" },
    -- { "<leader>K",  desc = "Signature Help" },
    -- { "<leader>g",  group = "LSP" },
    -- { "<leader>gP", desc = "Peek class" },
    -- { "<leader>ga", desc = "Add Workspace" },
    -- { "<leader>gr", desc = "Remove Workspace" },
    -- { "<leader>gd", desc = "Type Definition" },
    -- { "<leader>gf", desc = "Format" },
    -- { "<leader>gl", desc = "Show Workspace" },
    -- { "<leader>gp", desc = "Peek func" },
    -- { "<leader>gq", desc = "jq" },
    -- { "<leader>gn", desc = "Rename" },
    -- { "<leader>go", desc = "Code Action" },

        -- { "<leader>ge", desc = "RustOpenExtDocs" },
  -- { "<leader>g",  group = "Lang." },
  -- { "<leader>gS", desc = "LspStart" },
  -- { "<leader>gs", desc = "LspStop" },
  -- { "<leader>gt", desc = "LspRestart" },

  -- { "[L", desc = "Prev Class End" },
  -- { "[F", desc = "Prev Method End" },
  -- { "[l", desc = "Prev Class Start" },
  -- { "[f", desc = "Prev Method Start" },
  -- { "]L", desc = "Next Class End" },
  -- { "]F", desc = "Next Method End" },
  -- { "]l", desc = "Next Class Start" },
  -- { "]f", desc = "Next Method Start" },

  -- { "<leader>tn", desc = "Swap next node" },
  -- { "<leader>tp", desc = "Swap prev node" },
  -- { "<a-left>", desc = "Goto parent node" },
  -- { "<a-down>", desc = "Goto next node" },
  -- { "<a-up>", desc = "Goto prev node" },
  -- { "<a-right>", desc = "Goto child node" },
  -- { "<leader>tm", desc = "Highlight node" },
}
