local M = {}

M.opts = {
  preset = {
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files({ hidden = true })" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "e", desc = "GrEp", action = ":lua Snacks.picker.grep({ hidden = true, live = false, need_search = false })" },
      { icon = " ", key = "E", desc = "Live GrEp", action = ":lua Snacks.picker.grep({ hidden = true })" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
      { icon = " ", key = "d", desc = "Dotfiles", action = ":lua Snacks.picker.files({ cwd = '~/dotfiles', hidden = true })" },
      { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },
  sections = {
    { section = "keys", gap = 1, padding = 1 },
    {
      pane = 2,
      { title = '   nvim ' .. tostring(vim.version()), align = 'center' },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      { section = "startup" },
    },
  },
}

return M
