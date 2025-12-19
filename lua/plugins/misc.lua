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
    ft = 'arduino',
  },
  {
    'habamax/vim-godot',
    ft = 'gdscript',
  },
  {
    'elubow/cql-vim',
    ft = 'cqlang',
    config = function()
      require('utils').schedule_notify('cql loaded')
    end
  },
}
