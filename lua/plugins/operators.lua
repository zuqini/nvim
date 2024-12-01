return {
  'echasnovski/mini.operators',
  version = false,
  config = function()
    require('mini.operators').setup({
      replace = {
        prefix = 'gp',
      },
      exchange = {
        prefix = 'gP',
      },
    })
  end
};
