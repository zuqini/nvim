" Key bindings can be changed, see below
call wilder#setup({'modes': [':', '/', '?']})

call wilder#set_option('renderer', wilder#renderer_mux({
  \ ':': wilder#popupmenu_renderer({
  \   'pumblend': 10,
  \   'highlighter': wilder#basic_highlighter(),
  \   'highlights': {
  \     'accent': wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#fb4934', 'bold': 1, 'underline': 1 }]),
  \   },
  \   'left': [
  \     ' ', wilder#popupmenu_devicons(),
  \   ],
  \   'right': [
  \     ' ', wilder#popupmenu_scrollbar(),
  \    ],
  \ }),
  \ '/': wilder#wildmenu_renderer({
  \   'highlighter': wilder#basic_highlighter(),
  \   'separator': ' · ',
  \   'right': [' ', wilder#wildmenu_index()],
  \ }),
  \ }))
