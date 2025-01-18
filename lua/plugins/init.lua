local vrequire = require("utils").vrequire
return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
  },
  {
    'mbbill/undotree',
    init = function()
      vrequire('plugins/undotree')
    end
  },
  { 'stevearc/vim-arduino', ft = "arduino", },
  { 'habamax/vim-godot',    ft = "gdscript" },
}
