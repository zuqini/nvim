return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require('nvim-autopairs')
    npairs.setup({ disable_filetype = { "fzf" , "vim" } })
    -- npairs.remove_rule('`')
  end,
}
