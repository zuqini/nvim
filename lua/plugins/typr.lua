local cmd = {
  "Typr", "TyprStats"
}
return {
  {
    'nvzone/volt',
    cmd = cmd,
    priority = 1000,
  },
  {
    'nvzone/typr',
    cmd = cmd,
    config = function()
      require('typr').setup({ mode = "phrases", kblayout = "colemak_dh" })
    end
  },
}
