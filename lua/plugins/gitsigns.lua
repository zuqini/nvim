require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>,s', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>,r', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>,S', gs.stage_buffer)
    map('n', '<leader>,u', gs.undo_stage_hunk)
    map('n', '<leader>,R', gs.reset_buffer)
    map('n', '<leader>,p', gs.preview_hunk)
    map('n', '<leader>,b', function() gs.blame_line{full=true} end)
    map('n', '<leader>,tb', gs.toggle_current_line_blame)
    map('n', '<leader>,d', gs.diffthis)
    map('n', '<leader>,D', function() gs.diffthis('~') end)
    map('n', '<leader>,td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})
