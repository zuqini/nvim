return {
  'ThePrimeagen/harpoon', -- needs plenary
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function ()
    local opts = { noremap=true, silent=false}
    vim.keymap.set('n', '<leader>hp', require("harpoon.mark").add_file, opts)
    vim.keymap.set('n', '<leader>hh', require("harpoon.ui").toggle_quick_menu, opts)

    -- Colemak layout
    vim.keymap.set('n', '<leader>ha', function() require("harpoon.ui").nav_file(1) end, opts)
    vim.keymap.set('n', '<leader>hr', function() require("harpoon.ui").nav_file(2) end, opts)
    vim.keymap.set('n', '<leader>hs', function() require("harpoon.ui").nav_file(3) end, opts)
    vim.keymap.set('n', '<leader>ht', function() require("harpoon.ui").nav_file(4) end, opts)

    vim.keymap.set('n', '<leader>hz', function() require("harpoon.ui").nav_file(5) end, opts)
    vim.keymap.set('n', '<leader>hx', function() require("harpoon.ui").nav_file(6) end, opts)
    vim.keymap.set('n', '<leader>hc', function() require("harpoon.ui").nav_file(7) end, opts)
    vim.keymap.set('n', '<leader>hd', function() require("harpoon.ui").nav_file(8) end, opts)

    vim.keymap.set('n', '<leader>hq', function() require("harpoon.ui").nav_file(9) end, opts)
    vim.keymap.set('n', '<leader>hw', function() require("harpoon.ui").nav_file(10) end, opts)
    vim.keymap.set('n', '<leader>hf', function() require("harpoon.ui").nav_file(11) end, opts)

    -- vim.keymap.set('n', '<leader>h,', '<CMD>lua require("harpoon.ui").nav_file(vim.v.count1)<CR>', opts)

    require('which-key').register({
      h = {
        name = 'Harpoon',
        [','] = '{Count} Nav',
        p = 'Pin',
        h = 'Harpoon Menu',
        a = 'Nav 1',
        r = 'Nav 2',
        s = 'Nav 3',
        t = 'Nav 4',
        z = 'Nav 5',
        x = 'Nav 6',
        c = 'Nav 7',
        d = 'Nav 8',
        q = 'Nav 9',
        w = 'Nav 10',
        f = 'Nav 11',
      },
    }, { prefix = '<leader>' })
  end
}
