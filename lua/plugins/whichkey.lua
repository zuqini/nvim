return {
  'folke/which-key.nvim',
  config = function ()
    local wk = require("which-key")
    wk.setup({
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 35 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
    })
    -- vim.opt.timeoutlen = 500

    vim.api.nvim_set_keymap('n', '<leader><leader>', '<Cmd>WhichKey<CR>', { noremap = true, silent = true })

    wk.register({
      ['<C-S>'] = 'Set Working Dir',
      ['!'] = 'which_key_ignore',
    })

    wk.register({
      w = 'Save',
      W = 'Save & Quit',
      z = 'Auto Center',
      u = 'UndoTree',
      R = 'Read :cmd',
      k = 'Quickfix Prev',
      j = 'Quickfix Next',
      c = 'Clipboard y',
      C = 'Clipboard Y',
      x = 'Clipboard d',
      X = 'Clipboard D',
      y = 'Clipboard y',
      Y = 'Clipboard Y',
      v = 'Clipboard p',
      V = 'Clipboard P',
      p = 'Last Yanked p',
      P = 'Last Yanked P',
      g = {
        h = 'Open GH file',
        H = 'Open GH repo',
      }
    }, { prefix='<leader>' })

    wk.register({
      q = 'Quit Cur',
      Q = 'Quit! Cur',
      b = 'Del Buf',
      B = 'Del All Others',
    }, { prefix = '<BS>' })

    wk.register({
      s = 'Search (Leap)',
      ["<S-Tab>"] = 'NvimTreeToggle',
      ["<leader><Tab>"] = 'NvimTreeFindFile',

      ['[b'] = 'Prev Buffer',
      [']b'] = 'Next Buffer',
    })
  end
}
