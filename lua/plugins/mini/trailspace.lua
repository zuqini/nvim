return {
  'echasnovski/mini.trailspace',
  version = false,
  config = function()
    require('mini.trailspace').setup()
      vim.api.nvim_create_user_command('TrimTrail', ':lua MiniTrailspace.trim()', { nargs = 0 })   --Edit current path
      vim.api.nvim_create_user_command('TrimTrailLine', ':lua MiniTrailspace.trim_last_lines()', { nargs = 0 })   --Edit current path
  end
};
