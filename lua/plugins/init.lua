local vrequire = require("utils").vrequire
return {
  {
    'junegunn/fzf.vim',
    enabled = vim.g.fuzzy_search_plugin == 'fzf.vim',
    dependencies = { 'junegunn/fzf' },
    config = function()
      vrequire('plugins.fzf');
    end
  },
  {
    'mbbill/undotree',
    keys = { '<leader>u' },
    config = function()
      vrequire('plugins/undotree')
    end
  },
  { 'kylechui/nvim-surround', event = 'VeryLazy', config = true }, -- @TODO: lazy load with keys
  { 'stevearc/vim-arduino',   ft = "arduino", },
  { 'habamax/vim-godot',      ft = "gdscript" },
  { 'tpope/vim-fugitive',     cmd = 'G' },
}
