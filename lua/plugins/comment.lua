return {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    keys = {
      { 'gc', mode = { 'x', 'v', 'n' } },
      { 'gb', mode = { 'x', 'v', 'n' } },
    },
    config = function ()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
}
