require'fzf-lua'.setup {
    winopts = {
        height = 0.90,
        width = 0.85,
        preview = {
            layout = 'vertical',
            vertical = 'down:75%',
        },
    },
    fzf_opts = {
        ['--layout'] = 'default',
        ['--keep-right'] = '',
    }
}
