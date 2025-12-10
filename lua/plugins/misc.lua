local vrequire = require("utils").vrequire
return {
  {
    'mbbill/undotree',
    cmd = { 'U', 'UndotreeToggle' },
    config = function()
      vrequire('plugins/undotree')
    end
  },
  {
    'stevearc/vim-arduino',
    event = 'BufNew',
    pattern = '*.ino',
  },
  {
    'habamax/vim-godot',
    event = 'BufNew',
    pattern = '*.gdscript',
  },
  { 'elubow/cql-vim' },
}
