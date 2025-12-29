local cmd = { "Typr", "TyprStats" }
return {
  {
    'nvzone/volt',
    cmd = cmd,
    keys = '<leader>a',
    priority = 1000,
  },
  {
    'nvzone/typr',
    cmd = cmd,
    keys = { '<leader>a', ":Typr<CR>" },
    opts = { mode = "phrases", kblayout = "colemak_dh" },
  },
}
