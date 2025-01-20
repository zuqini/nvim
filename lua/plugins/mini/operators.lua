return {
  'echasnovski/mini.operators',
  version = false,
  event = 'VeryLazy',
  config = function()
    require('mini.operators').setup({
      replace = {
        prefix = 'gp',
      },
    })
  end
};
