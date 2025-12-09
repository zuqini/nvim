local vrequire = require("utils").vrequire
return {
  {
    'mbbill/undotree',
    config = function()
      vrequire('plugins/undotree')
    end
  },
  { 'stevearc/vim-arduino' },
  { 'habamax/vim-godot' },
}
