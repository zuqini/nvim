require("which-key").setup {
  layout = {
    height = { min = 4, max = 8 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
}
vim.opt.timeoutlen = 750

