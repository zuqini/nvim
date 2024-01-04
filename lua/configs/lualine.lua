 require('lualine').setup {
    options = {
        theme = 'spaceduck',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        icons_enabled = false,
    },
    sections = {
        lualine_a = {
            {
                'mode', 
                fmt = string.upper,
            }
        },
        lualine_b = { { 'branch' } },
        lualine_c = { {'filename', file_status = true, } },
        lualine_x = { {'encoding', 'fileformat', 'filetype' } },
        lualine_y = { {'progress' } },
        lualine_z = { {'location' } },
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
