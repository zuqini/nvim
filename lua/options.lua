vim.o.winblend = 10

vim.diagnostic.config({
  virtual_text = {
    prefix = '󱡞 ',
    -- prefix = '  ',
    -- prefix = '  ',
    -- suffix = '  ',
    -- suffix = '  ',
    -- suffix = ' ',
    -- suffix = '  ',
    suffix = '  ',
    -- suffix = ' ',
    virt_text_pos = 'eol_right_align',
  },
  virtual_lines = { current_line = vim.g.virtual_line_current_line },
})
