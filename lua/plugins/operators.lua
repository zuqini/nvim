return {
  'echasnovski/mini.operators',
  version = false,
  config = function()
    require('mini.operators').setup({
      exchange = {
        prefix = 'gp',
      },
      replace = {
        prefix = 'gP',
      },
    })
  end
};
