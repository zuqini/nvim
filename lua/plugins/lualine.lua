local winbar = {
  {
    'filetype',
    colored = true,   -- Displays filetype icon in color if set to true
    icon_only = true, -- Display only an icon for filetype
    padding = { left = 2, right = 0 },
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  {
    'filename',
    file_status = true,
    path = 1,
    -- shorting_target = 40,
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
    -- section_separators = '',
    -- component_separators = '|',

    -- component_separators = { left = '\\', right = '/'},
    -- section_separators = { left = '', right = '' },

    component_separators = { left = '/', right = '\\'},
    section_separators = { left = '', right = '' },

    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},

    -- component_separators = { left = '', right = '' },
    -- section_separators = { left = '', right = '' },

    icons_enabled = true,
    globalstatus = true,
    disabled_filetypes = {'NvimTree'},

    -- Uncomment to disable icons
    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
    -- icons_enabled = false,
  },
  winbar = {
    lualine_a = {},
    lualine_b = winbar,
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = winbar,
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
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
      -- { 'diff', separator = '|' },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', },

        sections = { 'error', 'warn', 'info', 'hint' },
        -- separator = '|',

        symbols = { error = ' ', warn = ' ', info = ' ', hint = 'ﯦ ' },
        colored = true,           -- Displays diagnostics status in color if set to true.
        update_in_insert = false, -- Update diagnostics in insert mode.
        always_visible = false,   -- Show diagnostics even if there are none.
      },
    },
    lualine_x = {
      {
        'filetype',
        -- separator = '|',
        separator = '·',
      },
      {
        'fileformat',
        -- separator = '|',
        separator = '·',
      },
      {
        'encoding',
        -- separator = '|',
        separator = '·',
      },
      {
        'filesize',
        -- separator = '|',
        separator = '·',
      },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  extensions = { 'fzf' },
}
