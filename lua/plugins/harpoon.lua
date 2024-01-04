local opts = { noremap=true, silent=false}
vim.keymap.set('n', ',p', require("harpoon.mark").add_file, opts)
vim.keymap.set('n', ',m', require("harpoon.ui").toggle_quick_menu, opts)

vim.keymap.set('n', ',a', function() require("harpoon.ui").nav_file(1) end, opts)
vim.keymap.set('n', ',r', function() require("harpoon.ui").nav_file(2) end, opts)
vim.keymap.set('n', ',s', function() require("harpoon.ui").nav_file(3) end, opts)
vim.keymap.set('n', ',t', function() require("harpoon.ui").nav_file(4) end, opts)
