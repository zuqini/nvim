return {
  'pechorin/any-jump.vim',
  init = function()
    vim.g.any_jump_disable_default_keybindings = 1
    vim.keymap.set('n', 'grj', ':AnyJump<CR>', { desc = 'AnyJump', noremap = true })
    vim.keymap.set('x', 'grj', ':AnyJumpVisual<CR>', { desc = 'AnyJump', noremap = true })
    vim.keymap.set('n', '<leader>a', ':AnyJumpLastResults<CR>', { desc = 'AnyJumpLastResults', noremap = true })
    -- vim.api.nvim_create_user_command('AL', 'AnyJumpLastResults', { bang = true })
  end,
}
