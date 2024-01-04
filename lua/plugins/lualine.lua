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
    tabline = {
        lualine_a = {
            {
                'tabs',
                mode = 0,
                component_separators = { left = '\\', right = '/'},
                section_separators = { left = '', right = '' },
            },
        },
        lualine_b = {
            {
                'filename',
                file_status = true,     -- Displays file status (readonly status, modified status)
                path = 0,               -- 0: Just the filename
                                        -- 1: Relative path
                                        -- 2: Absolute path

                -- shorting_target = 40,
                symbols = {
                    modified = '[+]',
                    readonly = '[-]',
                    unnamed = '[]',
                },
                separator = '',
                padding = { left = 1, right = 1 },
                section_separators = { left = '', right = '' },
            },
            {
                'filetype',
                colored = true,   -- Displays filetype icon in color if set to true
                icon_only = true, -- Display only an icon for filetype
                padding = { left = 0, right = 1 },
            },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            -- {
            --     'buffers',
            --     filetype_names = {
            --         TelescopePrompt = 'Telescope',
            --         dashboard = 'Dashboard',
            --         packer = 'Packer',
            --         fzf = 'FZF',
            --         alpha = 'Alpha'
            --     },
            --     show_filename_only = true,   -- Shows shortened relative path when set to false.
            --     hide_filename_extension = true,   -- Hide filename extension when set to true.
            --     symbols = {
            --         modified = '[+]',
            --     },
            -- }
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
            -- {
            --     'filename',
            --     file_status = true,     -- Displays file status (readonly status, modified status)
            --     path = 0,               -- 0: Just the filename
            --                             -- 1: Relative path
            --                             -- 2: Absolute path

            --     -- shorting_target = 80,
            --     symbols = {
            --         modified = '[+]',
            --         readonly = '[-]',
            --         unnamed = '[]',
            --     },
            -- },
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
