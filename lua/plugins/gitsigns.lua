return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  opts = {
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
      end, { expr = true, desc = 'Next Hunk', noremap = true })

      map('n', '[g', function()
        if vim.wo.diff then return '[g' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'Next Hunk', noremap = true })

      -- Actions
      map({ 'n', 'x' }, '<Leader>.s', ':Gitsigns stage_hunk<CR>', { desc = 'Stage Hunk', noremap = true })
      map({ 'n', 'x' }, '<Leader>.r', ':Gitsigns reset_hunk<CR>', { desc = 'Reset Hunk', noremap = true })
      map('n', '<Leader>.S', gs.stage_buffer, { desc = 'Stage Buffer', noremap = true })
      map('n', '<Leader>.u', gs.undo_stage_hunk, { desc = 'Undo Stage Hunk', noremap = true })
      map('n', '<Leader>.R', gs.reset_buffer, { desc = 'Reset Buffer', noremap = true })
      map('n', '<Leader>.p', gs.preview_hunk, { desc = 'Preview Hunk', noremap = true })
      map('n', '<Leader>.b', function() gs.blame_line { full = true } end, { desc = 'Blame Line', noremap = true })
      map('n', '<Leader>.tb', gs.toggle_current_line_blame, { desc = 'Toggle Blame Line', noremap = true })
      map('n', '<Leader>.d', function() gs.diffthis('~') end, { desc = 'Git Diff', noremap = true })
      map('n', '<Leader>.td', gs.toggle_deleted, { desc = 'Toggle Deleted', noremap = true })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Inner Hunk', noremap = true })
    end
  },
}
