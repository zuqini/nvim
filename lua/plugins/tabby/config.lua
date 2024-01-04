local header = require('utils.theme-hot-reload').get_current_tabby_header()

vim.o.showtabline = 2
local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLineSel',
  current_tab = 'TabLine',
  tab = 'TabLineFill',
  tail = 'TabLineSel',
}
require('tabby.tabline').set(function(line)
  return {
    {
      { header, hl = theme.head },
      line.sep('', theme.head, theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.fill
      return {
        line.sep(tab.is_current() and '' or '', hl, theme.fill),
        tab.is_current() and '' or '',
        tab.number(),
        tab.name(),
        line.sep(tab.is_current() and '' or '', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      local hl = win.is_current() and theme.current_tab or theme.fill
      return {
        line.sep(win.is_current() and '' or '', hl, theme.fill),
        win.is_current() and '' or '',
        win.buf_name(),
        line.sep(win.is_current() and '' or '', hl, theme.fill),
        hl = hl,
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

vim.api.nvim_create_user_command('TR', "TabRename <args>", { nargs = "?", bang = true })
vim.api.nvim_create_user_command('TS', "tab split", { bang = true })
vim.api.nvim_create_user_command('VS', "vs", { bang = true })
vim.api.nvim_create_user_command('SP', "sp", { bang = true })
