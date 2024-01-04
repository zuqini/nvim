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
    },
    fzf_colors = {
        ["fg"]          = { "fg", "CursorLine" },
        ["bg"]          = { "bg", "Normal" },
        ["hl"]          = { "fg", "Comment" },
        ["fg+"]         = { "fg", "Normal" },
        ["bg+"]         = { "bg", "CursorLine" },
        ["hl+"]         = { "fg", "Statement" },
        ["info"]        = { "fg", "PreProc" },
        ["prompt"]      = { "fg", "Conditional" },
        ["pointer"]     = { "fg", "Exception" },
        ["marker"]      = { "fg", "Keyword" },
        ["spinner"]     = { "fg", "Label" },
        ["header"]      = { "fg", "Comment" },
        ["gutter"]      = { "bg", "Normal" },
    }
}
