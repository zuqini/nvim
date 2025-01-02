local map = function(mode, mapping, rhs, desc)
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true })
end
return {
  {
    'drybalka/tree-climber.nvim',
    config = function()
      local tc = require('tree-climber')
      local opts = { skip_comments = true, highlight = true, higroup = 'Folded', timeout = 500 }
      -- map({ 'v', 'o' }, 'iN', function() tc.select_node(opts) end, 'Select Node')
      -- map({ 'n', 'v', 'o' }, '<a-h>', function() tc.goto_parent(opts) end, 'Goto Parent')
      -- map({ 'n', 'v', 'o' }, '<a-j>', function() tc.goto_next(opts) end, 'Goto Next')
      -- map({ 'n', 'v', 'o' }, '<a-k>', function() tc.goto_prev(opts) end, 'Goto Prev')
      -- map({ 'n', 'v', 'o' }, '<a-l>', function() tc.goto_child(opts) end, 'Goto Child')
      -- map('n', '<leader>tm', function() tc.highlight_node(opts) end, 'Highlight Node')
      map('n', '<leader>tp', function() tc.swap_prev(opts) end, 'Swap Prev')
      map('n', '<leader>tn', function() tc.swap_next(opts) end, 'Swap Next')
    end
  },
  {
    "aaronik/treewalker.nvim",
    opts = {
      highlight = true, -- Whether to briefly highlight the node after jumping to it
      highlight_duration = 150, -- How long should above highlight last (in ms)
    },
    config = function()
      map({ 'n', 'v' }, '<A-k>', '<cmd>Treewalker Up<cr>', 'Treewalker Up')
      map({ 'n', 'v' }, '<A-j>', '<cmd>Treewalker Down<cr>', 'Treewalker Down')
      map({ 'n', 'v' }, '<A-l>', '<cmd>Treewalker Right<cr>', 'Treewalker Right')
      map({ 'n', 'v' }, '<A-h>', '<cmd>Treewalker Left<cr>', 'Treewalker Left')
      map('n', '<leader>tj', '<cmd>Treewalker SwapDown<cr>', 'Swap Down')
      map('n', '<leader>tk', '<cmd>Treewalker SwapUp<cr>', 'Swap Up')
      -- vim.keymap.set('n', '<leader>tn', ":TSTextobjectSwapNext @parameter.inner<CR>", { noremap = true, silent = true })
      -- vim.keymap.set('n', '<leader>tp', ":TSTextobjectSwapPrevious @parameter.inner<CR>", { noremap = true, silent = true })
    end
  },
}
