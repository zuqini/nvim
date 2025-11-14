-- Neovim bug, see https://github.com/neovim/neovim/issues/18576
if not vim.g.no_winblend_if_transparent or not vim.g.transparent_background then
  vim.o.winblend = vim.g.winblend
end

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
