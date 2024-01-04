local vrequire = require("utils").vrequire
return {
  -- FZF
  { 'junegunn/fzf', build = (vim.g.is_window and '' or './install --bin') },
  {
    'junegunn/fzf.vim',
    enabled = vim.g.is_windows,
    event = 'VeryLazy',
    config = function ()
      vrequire('plugins.fzf');
    end
  },
  --  Utils
  { 'stevearc/vim-arduino', ft = "arduino", },
  {
    'darfink/vim-plist',
    ft={ "plist", "strings" },
    config = function ()
      vrequire("plugins/plist")
    end
  },
  {
    'mbbill/undotree',
    keys = { '<leader>u' },
    config = function ()
      vrequire('plugins/undotree')
    end
  },
  {
    'petertriho/nvim-scrollbar',
    event = 'VeryLazy',
    config = true,
  },
  {
    'kylechui/nvim-surround', -- ys,ds,cs,ts
    event = 'VeryLazy',
    config = true,
  },
  { "dstein64/vim-startuptime", cmd = "StartupTime", },
  'tpope/vim-commentary', -- gc
  'tpope/vim-repeat',
  'michaeljsmith/vim-indent-object', -- ii, ai, iI, aI
}
