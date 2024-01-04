vim.o.showtabline = 2
local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  tail = 'TabLine',
}
require('tabby.tabline').set(function(line)
  return {
    {
      line.sep(' ', theme.head, theme.fill),
      { '  ', hl = theme.head },
      line.sep(' ', theme.head, theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.fill
      return {
        tab.is_current() and line.sep('', hl, theme.fill) or line.sep(' ', theme.tab, theme.fill),
        tab.is_current() and '' or '',
        tab.number(),
        tab.name(),
        tab.is_current() and line.sep('', hl, theme.fill) or line.sep(' ', theme.tab, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      local hl = win.is_current() and theme.current_tab or theme.fill
      return {
        win.is_current() and line.sep('', hl, theme.fill) or line.sep(' ', theme.tab, theme.fill),
        win.is_current() and '' or '',
        win.buf_name(),
        win.is_current() and line.sep('', hl, theme.fill) or line.sep(' ', theme.tab, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    {
      line.sep(' ', theme.tail, theme.fill),
      { '  ', hl = theme.tail },
      line.sep(' ', theme.tail, theme.fill),
    },
    hl = theme.fill,
  }
end, {
  tab_name = {
    name_fallback = function(tabid)
      return ""
    end
  }
})
vim.api.nvim_create_user_command(
  'TR',
  "TabRename <args>",
  { nargs = "?", bang = true }
)

vim.api.nvim_create_user_command(
  'TS',
  "tab split",
  { bang = true }
)
