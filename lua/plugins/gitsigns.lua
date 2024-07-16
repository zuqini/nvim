return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  config = function ()
    require('gitsigns').setup({
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']g', function()
          if vim.wo.diff then return ']g' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[g', function()
          if vim.wo.diff then return '[g' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        -- Actions
        map({'n', 'v'}, '<leader>;s', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<leader>;r', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>;S', gs.stage_buffer)
        map('n', '<leader>;u', gs.undo_stage_hunk)
        map('n', '<leader>;R', gs.reset_buffer)
        map('n', '<leader>;p', gs.preview_hunk)
        map('n', '<leader>;b', function() gs.blame_line{full=true} end)
        map('n', '<leader>;tb', gs.toggle_current_line_blame)
        map('n', '<leader>;d', function() gs.diffthis('~') end)
        map('n', '<leader>;td', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    })

    require('which-key').add({
      { "[g", desc = "Prev Hunk" },
      { "]g", desc = "Next Hunk" },
      { "<leader>;", group = "GitSigns" },
      { "<leader>;R", desc = "Reset Buffer" },
      { "<leader>;S", desc = "Stage Buffer" },
      { "<leader>;b", desc = "Blame" },
      { "<leader>;d", desc = "Diff" },
      { "<leader>;p", desc = "Preview Hunk" },
      { "<leader>;r", desc = "Reset Hunk" },
      { "<leader>;s", desc = "Stage Hunk" },
      { "<leader>;t", group = "Toggle" },
      { "<leader>;tb", desc = "Blame" },
      { "<leader>;td", desc = "Deleted" },
      { "<leader>;u", desc = "Undo Stage Hunk" },
    })
  end
}
