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
    event = {
      event = 'FileType',
      pattern = 'arduino',
    },
  },
  {
    'habamax/vim-godot',
    event = {
      event = 'FileType',
      pattern = 'gdscript',
    },
  },
  {
    'elubow/cql-vim',
    -- vim plugins need to be loaded before entering
    event = {
      event = 'BufReadPre',
      pattern = '*.cql',
    },
  },
}
