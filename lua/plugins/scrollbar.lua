return {
  'petertriho/nvim-scrollbar',
  event = 'VeryLazy',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'kevinhwang91/nvim-hlslens',
  },
  config = function()
    require("scrollbar.handlers.search").setup({
      override_lens = function() end,
    })
    require("scrollbar.handlers.gitsigns").setup()

    -- some colorschemes seems to not work well w/ default highlight
    require("scrollbar").setup({
      excluded_filetypes = {
        "dropbar_menu",
        "dropbar_menu_fzf",
        "DressingInput",
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "blink-cmp-menu",
        "blink-cmp-signature",
        "blink-cmp-documentation",
      },
      handle = {
        color = '#333333',
      },
      marks = {
        Cursor = { color = '#dddddd' },
        Search = { color = '#ff9664' },
        Error = { color = '#ff1200' },
        Warn = { color = '#ffed00' },
        Info = { color = '#73a3b7' },
        Hint = { color = '#8eb2af' },
        Misc = { color = '#d38d97' },
        GitAdd = { color = '#67b0e8' },
        GitChange = { color = '#c47fd5' },
        GitDelete = { color = '#e57474' },
      }
    })
  end,
}
