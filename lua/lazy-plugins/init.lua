local vrequire = require("utils").vrequire
return {
  {
    'mbbill/undotree',
    init = function()
      vrequire('plugins/undotree')
    end
  },
  { 'stevearc/vim-arduino', ft = "arduino", },
  { 'habamax/vim-godot',    ft = "gdscript" },
}
