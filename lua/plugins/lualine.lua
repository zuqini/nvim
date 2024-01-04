require('lualine').setup {
    options = {
        -- component_separators = '|',
        -- section_separators = { left = '', right = ''},

        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        icons_enabled = true,

        -- Uncomment to disable icons
        -- component_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = ''},
        -- icons_enabled = false,
    },
    tabline = {
        lualine_a = {
            {
                'tabs',
                mode = 0,
            },
        },
        lualine_b = {
            {
                'filename',
                file_status = true,     -- Displays file status (readonly status, modified status)
                path = 0,               -- 0: Just the filename
                                        -- 1: Relative path
                                        -- 2: Absolute path

                shorting_target = 40,
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
            {
                'branch',
                icon = '',
                separator = ':'
            },
            {
                'filename',
                file_status = true,     -- Displays file status (readonly status, modified status)
                path = 1,               -- 0: Just the filename
                                        -- 1: Relative path
                                        -- 2: Absolute path

                shorting_target = 80,
                symbols = {
                    modified = '[+]',
                    readonly = '[-]',
                    unnamed = '[]',
                },
            },
        },
        lualine_c = {
            { 'diff', separator = '|' },
            {
                'diagnostics',
                sources = { 'nvim_diagnostic', },

                sections = { 'error', 'warn', 'info', 'hint' },
                separator = '|',

                symbols = { error = ' ', warn = ' ', info = ' ', hint = 'ﯦ ' },
                colored = true,           -- Displays diagnostics status in color if set to true.
                update_in_insert = false, -- Update diagnostics in insert mode.
                always_visible = false,   -- Show diagnostics even if there are none.
            },
        },
        lualine_x = {
            { 'filetype', separator = '|' },
            { 'fileformat', separator = '|' },
            { 'encoding', separator = '|' },
            { 'filesize', separator = '|' },
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    inactive_sections = {
        lualine_a = {  },
        lualine_b = { 'filename' },
        lualine_c = {  },
        lualine_x = {  },
        lualine_y = { 'location' },
        lualine_z = {  },
    },
    extensions = { 'fzf' },
}
