local theme = require('utils.theme-hot-reload').get_current_lualine_theme()

local no_seps = { left = '', right = '' }
local angle_down_seps = { left = '', right = '' }
local angle_up_seps = { left = '', right = '' }
local triangle_seps = { left = '', right = '' }
local circle_seps = { left = '', right = '' }

local angle_down_thin_seps = { left = '\\', right = '/' }
local angle_up_thin_seps = { left = '/', right = '\\' }
local angle_down_thin2_seps = { left = '', right = '' }
local angle_up_thin2_seps = { left = '', right = '' }
local triangle_thin_seps = { left = '', right = '' }
local circle_thin_seps = { left = '', right = '' }

-- local signs = { Error = '', Warn = '', Info = '', Hint = 'ﯦ' }
-- local symbols = { error = ' ', warn = ' ', info = ' ', hint = 'ﯦ ' }
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
local symbols = { error = " ", warn = " ", hint = " ", info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local winbar =
{
  {
    'filetype',
    colored = true, -- Displays filetype icon in color if set to true
    icon_only = true, -- Display only an icon for filetype
    padding = { left = 1, right = 0 },
    component_separators = no_seps,
    section_separators = angle_up_seps,
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

local tabline = {
  lualine_a = {
    {
      'tabs',
      mode = 0,
    },
  }
};

local sections = {
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
      colored = true, -- Displays diagnostics status in color if set to true.
      update_in_insert = false, -- Update diagnostics in insert mode.
      always_visible = false, -- Show diagnostics even if there are none.
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
}

require('lualine').setup {
  options = {
    theme = theme,
    component_separators = angle_down_thin2_seps,
    section_separators = angle_down_seps,
    icons_enabled = true,
    globalstatus = true,

    -- Uncomment to disable icons
    -- icons_enabled = false,
  },
  winbar = { lualine_c = winbar },
  inactive_winbar = { lualine_c = winbar },
  -- tabline = tabline,
  sections = sections,
  extensions = { 'fzf' },
}
