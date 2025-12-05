return {
  'nvzone/typr',
  dependencies = { 'nvzone/volt' },
  config = function()
    require('typr').setup({ mode = "phrases", kblayout = "colemak_dh" })
  end
}
