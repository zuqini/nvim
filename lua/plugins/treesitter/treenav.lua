local map = function(mode, mapping, rhs, desc)
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true })
end

return {
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
}
