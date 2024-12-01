local tc = require('tree-climber')

local opts = { skip_comments = true, highlight = true, higroup = 'Folded', timeout = 500 }
local map = function(mode, mapping, rhs, desc)
  vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true })
end
local keyopts = { noremap = true, silent = true }

map({'v', 'o'}, 'in', function() tc.select_node(opts) end, 'Select Node')

map({'n', 'v', 'o'}, '<a-left>', function() tc.goto_parent(opts) end, 'Goto Parent')
map({'n', 'v', 'o'}, '<a-down>', function() tc.goto_next(opts) end, 'Goto Next')
map({'n', 'v', 'o'}, '<a-up>', function() tc.goto_prev(opts) end, 'Goto Prev')
map({'n', 'v', 'o'}, '<a-right>', function() tc.goto_child(opts) end, 'Goto Child')
map('n', '<leader>tm', function() tc.highlight_node(opts) end, 'Highlight Node')

map('n', '<leader>tp', function() tc.swap_prev(opts) end, 'Swap Prev')
map('n', '<leader>tn', function() tc.swap_next(opts) end, 'Swap Next')
