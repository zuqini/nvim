local tc = require('tree-climber')

local opts = { skip_comments = true, highlight = true, higroup = 'Folded', timeout = 500 }
local keyopts = { noremap = true, silent = true }

vim.keymap.set({'v', 'o'}, 'in', function() tc.select_node(opts) end, keyopts)

vim.keymap.set({'n', 'v', 'o'}, '<a-left>', function() tc.goto_parent(opts) end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<a-down>', function() tc.goto_next(opts) end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<a-up>', function() tc.goto_prev(opts) end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<a-right>', function() tc.goto_child(opts) end, keyopts)
vim.keymap.set('n', '<leader>tm', function() tc.highlight_node(opts) end, keyopts)

vim.keymap.set('n', '<leader>tp', function() tc.swap_prev(opts) end, keyopts)
vim.keymap.set('n', '<leader>tn', function() tc.swap_next(opts) end, keyopts)

require('which-key').add({
  { "<leader>tn", desc = "Swap next node" },
  { "<leader>tp", desc = "Swap prev node" },
  { "<a-left>", desc = "Goto parent node" },
  { "<a-down>", desc = "Goto next node" },
  { "<a-up>", desc = "Goto prev node" },
  { "<a-right>", desc = "Goto child node" },
  { "<leader>tm", desc = "Highlight node" },
})
