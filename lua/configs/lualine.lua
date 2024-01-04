local colors = {
  red = '#ca1243',
  grey = '#a0a1a7',
  black = '#383a42',
  white = '#f3f3f3',
  light_green = '#83a598',
  orange = '#fe8019',
  green = '#8ec07c',
}

 require('lualine').setup {
    options = {
        theme = 'spaceduck',
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = ''},

        component_separators = '|',
        section_separators = { left = '', right = '' },
        icons_enabled = true,

        -- Uncomment to disable icons
        -- component_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = ''},
        -- icons_enabled = false,
    },
    tabline = {
        lualine_a = { { 'tabs', mode = 0, }, },
        lualine_b = {
            {
                'filename',
                file_status = true,     -- Displays file status (readonly status, modified status)
                path = 1,               -- 0: Just the filename
                                        -- 1: Relative path
                                        -- 2: Absolute path

                shorting_target = 40,   -- Shortens path to leave 40 spaces in the window
                                        -- for other components. (terrible name, any suggestions?)
                symbols = {
                    modified = '[+]',
                    readonly = '[-]',
                    unnamed = '[]',
                },

                separator = '',
                padding = { left = 1, right = 0 },
            },
            {
                'filetype',
                colored = true,   -- Displays filetype icon in color if set to true
                icon_only = true, -- Display only an icon for filetype
                padding = { left = 1, right = 0 },
            },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            {
                'buffers',
                filetype_names = {
                    TelescopePrompt = 'Telescope',
                    dashboard = 'Dashboard',
                    packer = 'Packer',
                    fzf = 'FZF',
                    alpha = 'Alpha'
                },
            }
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
            'branch',
            'filetype',
        },
        lualine_c = {
            'diff',
            {
                'diagnostics',
                sources = { 'nvim_diagnostic', 'coc' },

                sections = { 'error', 'warn', 'info', 'hint' },

                symbols = { error = ' ', warn = ' ', info = ' ', hint = 'ﯦ' },
                colored = true,           -- Displays diagnostics status in color if set to true.
                update_in_insert = false, -- Update diagnostics in insert mode.
                always_visible = false,   -- Show diagnostics even if there are none.
            },
        },
        lualine_x = { 'encoding',  'filesize', 'fileformat' },
        lualine_y = { { 'progress' } },
        lualine_z = { { 'location' } },
    },
    inactive_sections = {
        lualine_a = {  },
        lualine_b = {  },
        lualine_c = { { 'filename' } },
        lualine_x = { { 'location' } },
        lualine_y = {  },
        lualine_z = {  },
    },
    extensions = { 'fzf' },
}
