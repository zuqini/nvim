return {
  'pechorin/any-jump.vim',
  keys = {
    { 'grj', ':AnyJump<CR>',       mode = 'n', desk = 'AnyJump' },
    { 'grj', ':AnyJumpVisual<CR>', mode = 'x', desk = 'AnyJump' },
  },
  cmd = { 'AnyJumpLastResults', 'AJ' },
  init = function()
    vim.g.any_jump_disable_default_keybindings = 1
    vim.api.nvim_create_user_command('AJ', 'AnyJumpLastResults', { bang = true })
  end,
}
