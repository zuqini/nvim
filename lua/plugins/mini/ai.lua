return {
  {
    'nvim-mini/mini.ai',
    event = "VeryLazy",
    dependencies = {
      'nvim-mini/mini.extra',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      local ai = require('mini.ai')
      local gen_spec = ai.gen_spec
      local gen_ai_spec = require('mini.extra').gen_ai_spec
      ai.setup({
        n_lines = 2000,
        custom_textobjects = {
          B = gen_ai_spec.buffer(),
          D = gen_ai_spec.diagnostic(),
          I = gen_ai_spec.indent(),
          L = gen_ai_spec.line(),
          N = gen_ai_spec.number(),
          m = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
          o = gen_spec.treesitter({ a = '@block.outer', i = '@block.inner' }),
          c = gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        },
      })
    end,
  },
}
