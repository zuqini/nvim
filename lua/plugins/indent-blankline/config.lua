local highlight = {
    "IblHighlightLevel1",
    "IblHighlightLevel2",
    "IblHighlightLevel3",
    "IblHighlightLevel4",
    "IblHighlightLevel5",
    "IblHighlightLevel6",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "IblHighlightLevel1", { fg = "#662121" })
    vim.api.nvim_set_hl(0, "IblHighlightLevel2", { fg = "#767621" })
    vim.api.nvim_set_hl(0, "IblHighlightLevel3", { fg = "#216631" })
    vim.api.nvim_set_hl(0, "IblHighlightLevel4", { fg = "#325a5e" })
    vim.api.nvim_set_hl(0, "IblHighlightLevel5", { fg = "#324b7b" })
    vim.api.nvim_set_hl(0, "IblHighlightLevel6", { fg = "#562155" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#00FF00" })
end)

require("ibl").setup {
  indent = {
    char =  '▏',
    highlight = highlight,
  },
  scope = {
    char =  '▎',
    -- show_start = false,
    -- show_end = false,
    -- -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/643#issuecomment-1740384318
    -- include = {
    --   node_type = {
    --     ['*'] = { '*' }
    --   }
    -- },
  }
}
