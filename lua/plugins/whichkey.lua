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
  u = 'Highlight',
  R = 'Source Nvim',
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
}, { prefix='<leader>' })

require('which-key').register({
  ['[b'] = 'Prev Buffer',
  [']b'] = 'Next Buffer',
})
