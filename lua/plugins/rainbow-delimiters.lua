return {
  'hiphish/rainbow-delimiters.nvim',
  enabled = true,
  event = 'VeryLazy',
  config = function()
    -- This module contains a number of default definitions
    local rainbow_delimiters = require 'rainbow-delimiters'

    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
      },
      highlight = {
        'RainbowDelimiterBlue',
        'RainbowDelimiterYellow',
        'RainbowDelimiterGreen',
        'RainbowDelimiterOrange',
        'RainbowDelimiterViolet',
        'RainbowDelimiterRed',
        'RainbowDelimiterCyan',
      },
    }
  end,
}
