vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- Change the "hint" color to the "orange" color, and make the "error" color bright red
-- vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }

-- Load the colorscheme
vim.cmd('colorscheme tokyonight')
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#272833" })
vim.api.nvim_set_hl(0, "Cursor", { bg = "#7E9CD8" })
