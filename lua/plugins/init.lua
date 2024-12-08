local vrequire = require("utils").vrequire
return {
  {
    'mbbill/undotree',
    config = function()
      vrequire('plugins/undotree')
    end
  },
  -- { 'kylechui/nvim-surround', event = 'VeryLazy', config = true }, -- @TODO: lazy load with keys
  {
    'echasnovski/mini.surround',
    version = false,
    config = function()
      require('mini.surround').setup()
    end
  },
  { 'stevearc/vim-arduino', ft = "arduino", },
  { 'habamax/vim-godot', ft = "gdscript" },
  { 'tpope/vim-fugitive', cmd = 'G' },
}
