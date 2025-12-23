local cmd = {
  "Typr", "TyprStats"
}
return {
  {
    'nvzone/volt',
    cmd = cmd,
    keys = '<leader>a',
    priority = 1000,
    config = function()
      require('utils').schedule_notify("volt loaded")
    end
  },
  {
    'nvzone/typr',
    cmd = cmd,
    keys = { '<leader>a', ":Typr<CR>" },
    config = function()
      require('utils').schedule_notify("typr loaded")
      require('typr').setup({ mode = "phrases", kblayout = "colemak_dh" })
    end
  },
}
