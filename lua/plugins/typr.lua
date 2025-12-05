return {
  { 'nvzone/volt' },
  {
    'nvzone/typr',
    config = function()
      require('typr').setup({ mode = "phrases", kblayout = "colemak_dh" })
    end
  },
}
