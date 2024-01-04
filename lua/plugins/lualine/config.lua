local theme = require('utils.theme-hot-reload').get_current_lualine_theme()

local separators0 = { left = '', right = '' }
local separators1 = { left = '', right = '' }
local separators2 = { left = '', right = '' }
local separators3 = { left = '', right = '' }
local separators4 = { left = '', right = '' }

local separators5 = { left = '\\', right = '/' }
local separators6 = { left = '/', right = '\\' }
local separators7 = { left = '', right = '' }
local separators8 = { left = '', right = '' }
local separators9 = { left = '', right = '' }
local separators10 = { left = '', right = '' }

-- local signs = { Error = '', Warn = '', Info = '', Hint = 'ﯦ' }
-- local symbols = { error = ' ', warn = ' ', info = ' ', hint = 'ﯦ ' }
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
local symbols = { error = " ", warn = " ", hint = " ", info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local winbar = {
  {
    'filetype',
    colored = true,   -- Displays filetype icon in color if set to true
    icon_only = true, -- Display only an icon for filetype
    padding = { left = 1, right = 0 },
    component_separators = separators0,
    section_separators = separators2,
  },
  {
    'filename',
    file_status = true,
    path = 1,
    symbols = {
      modified = '[+]',
      readonly = '[-]',
      unnamed = '[]',
    },
    separator = '',
  },
};
require('lualine').setup {
  options = {
    theme = theme,
    component_separators = separators9,
    section_separators = separators1,
    icons_enabled = true,
    globalstatus = true,

    -- Uncomment to disable icons
    -- icons_enabled = false,
  },
  winbar = {
    lualine_b = winbar,
  },
  inactive_winbar = {
    lualine_b = winbar,
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = string.upper,
      }
    },
    lualine_b = {
      {
        'branch',
        icon = '',
        separator = ':'
      },
      { 'diff' },
    },
    lualine_c = {
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', },

        sections = { 'error', 'warn', 'info', 'hint' },

        symbols = symbols,
        colored = true,           -- Displays diagnostics status in color if set to true.
        update_in_insert = false, -- Update diagnostics in insert mode.
        always_visible = false,   -- Show diagnostics even if there are none.
      },
    },
    lualine_x = {
      {
        'filetype',
        separator = '·',
      },
      {
        'fileformat',
        separator = '·',
      },
      {
        'encoding',
        separator = '·',
      },
      {
        'filesize',
        separator = '·',
      },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  extensions = { 'fzf' },
}
