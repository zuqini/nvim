local hl_list = {}
for i, color in pairs({ '#662121', '#767621', '#216631', '#325a5e', '#324b7b', '#562155' }) do
  local name = 'IndentBlanklineIndent' .. i
  vim.api.nvim_set_hl(0, name, { fg = color })
  table.insert(hl_list, name);
end
require('indent_blankline').setup {
  use_treesitter = true,
  show_current_context = true,
  show_current_context_start = true,
  char_highlight_list = hl_list,
}
vim.g.indent_blankline_char = '▏'
vim.g.indent_blankline_context_char = '▎'
vim.cmd [[highlight IndentBlanklineContextStart guisp=#00FF00 gui=underline]]
vim.cmd [[highlight IndentBlanklineContextChar guifg=#00FF00 gui=nocombine]]
