return {
  'ThePrimeagen/harpoon', -- needs plenary
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function ()
    local opts = { noremap=true, silent=false}
    vim.keymap.set('n', ',p', require("harpoon.mark").add_file, opts)
    vim.keymap.set('n', ',h', require("harpoon.ui").toggle_quick_menu, opts)

    vim.keymap.set('n', ',a', function() require("harpoon.ui").nav_file(1) end, opts)
    vim.keymap.set('n', ',r', function() require("harpoon.ui").nav_file(2) end, opts)
    vim.keymap.set('n', ',s', function() require("harpoon.ui").nav_file(3) end, opts)
    vim.keymap.set('n', ',t', function() require("harpoon.ui").nav_file(4) end, opts)
    vim.keymap.set('n', ',z', function() require("harpoon.ui").nav_file(5) end, opts)
    vim.keymap.set('n', ',x', function() require("harpoon.ui").nav_file(6) end, opts)
    vim.keymap.set('n', ',c', function() require("harpoon.ui").nav_file(7) end, opts)
    vim.keymap.set('n', ',d', function() require("harpoon.ui").nav_file(8) end, opts)

    vim.keymap.set('n', ',,', '<CMD>lua require("harpoon.ui").nav_file(vim.v.count1)<CR>', opts)

    require('which-key').register({
      [','] = 'Buffer',
    })

    require('which-key').register({
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
      q = 'Quit Cur',
      Q = 'Quit! Cur',
      b = 'Del Buf',
      B = 'Del All Others',
    }, { prefix = ',' })
  end
}
