vim.o.showtabline = 2
local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLineSel',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLineSel',
}
require('tabby.tabline').set(function(line)
  return {
    {
      { '  ', hl = theme.head },
      line.sep('', theme.head, theme.fill),
    },
    line.tabs().foreach(function(tab)
      return {
        line.sep('', theme.tab, theme.fill),
        tab.is_current() and '' or '',
        tab.number(),
        tab.name(),
        line.sep('', theme.tab, theme.fill),
        hl = theme.tab,
        margin = ' ',
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      return {
        line.sep('', theme.win, theme.fill),
        win.is_current() and '' or '',
        win.buf_name(),
        line.sep('', theme.win, theme.fill),
        hl = theme.win,
        margin = ' ',
      }
    end),
    {
      line.sep('', theme.tail, theme.fill),
      { '  ', hl = theme.tail },
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
