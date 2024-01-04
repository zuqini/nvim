local tc = require('tree-climber')

local opts = { skip_comments = true, highlight = true, higroup = 'Folded', timeout = 500 }
local keyopts = { noremap = true, silent = true }

vim.keymap.set({'v', 'o'}, 'in', function() tc.select_node(opts) end, keyopts)

vim.keymap.set({'n', 'v', 'o'}, '<A-j>', function() tc.goto_next(opts) end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<A-h>', function() tc.goto_parent(opts) end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<A-k>', function() tc.goto_prev(opts) end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<A-l>', function() tc.goto_child(opts) end, keyopts)
vim.keymap.set('n', '<A-m>', function() tc.highlight_node(opts) end, keyopts)

vim.keymap.set('n', '<C-p>', function() tc.swap_prev(opts) end, keyopts)
vim.keymap.set('n', '<C-n>', function() tc.swap_next(opts) end, keyopts)

