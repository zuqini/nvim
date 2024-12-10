return {
  'echasnovski/mini.ai',
  version = false,
  dependencies = { 'echasnovski/mini.extra', version = false },
  config = function()
    local gen_ai_spec = require('mini.extra').gen_ai_spec
    require('mini.ai').setup({
      custom_textobjects = {
        B = gen_ai_spec.buffer(),
        D = gen_ai_spec.diagnostic(),
        I = gen_ai_spec.indent(),
        L = gen_ai_spec.line(),
        N = gen_ai_spec.number(),
      },
    })
  end,
}
