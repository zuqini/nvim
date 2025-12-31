return {
  {
    'nvzone/typr',
    cmd = { "Typr", "TyprStats" },
    keys = { '<leader>a', ":Typr<CR>" },
    dependencies = { 'nvzone/volt' },
    opts = { mode = "phrases", kblayout = "colemak_dh" },
  },
}
