local separators0 = { left = '', right = ''}
local separators1 = { left = '', right = '' }
local separators2 = { left = '', right = '' }
-- local separators3 = { left = '', right = ''}
-- local separators4 = { left = '', right = '' }

-- local separators5 = { left = '\\', right = '/'}
-- local separators6 = { left = '/', right = '\\'}
-- local separators7 = { left = '', right = ''}
-- local separators8 = { left = '', right = '' }
local separators9 = { left = '', right = ''}
-- local separators10 = { left = '', right = ''}

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
    component_separators = separators9,
    section_separators = separators1,
    icons_enabled = true,
    globalstatus = true,
    disabled_filetypes = {'NvimTree'},

    -- Uncomment to disable icons
    -- icons_enabled = false,
  },
  winbar = {
    lualine_b = winbar,
  },
  inactive_winbar = {
    lualine_b = winbar,
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        filetype_names = {
          TelescopePrompt = 'Telescope',
          dashboard = 'Dashboard',
          packer = 'Packer',
          fzf = 'FZF',
          alpha = 'Alpha'
        },
        show_filename_only = true,   -- Shows shortened relative path when set to false.
        hide_filename_extension = true,   -- Hide filename extension when set to true.
        max_length = vim.o.columns - 15 - 5; -- 15 is the length of tabs defined below + 5 for padding

        symbols = {
          modified = '[+]',
          unnamed = '[]',
          readonly = '[-]',
        },
      }
    },
    lualine_z = {
      {
        'tabs',
        mode = 0,
        max_length = 15;
      },
    },
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
