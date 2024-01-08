local vrequire = require("utils").vrequire
return {
  -- FZF, consider replacing/complementing with telescope
  -- even though telescope is slower, it's much better integrated with other plugins
  -- see: https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
  {
    'junegunn/fzf.vim',
    enabled = vim.g.search_with_fzf_vim,
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
}
