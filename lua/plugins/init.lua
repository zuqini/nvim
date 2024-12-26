local vrequire = require("utils").vrequire
return {
  {
    'mbbill/undotree',
    config = function()
      vrequire('plugins/undotree')
    end
  },
  { 'stevearc/vim-arduino', ft = "arduino", },
  { 'habamax/vim-godot', ft = "gdscript" },
}
