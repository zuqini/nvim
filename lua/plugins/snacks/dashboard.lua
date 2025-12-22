local picker = require('plugins.snacks.picker')

local M = {}

M.opts = {
  preset = {
    keys = {
      { icon = " ", key = "ff", desc = "Find File", action = picker.smart },
      { icon = " ", key = "fe", desc = "GrEp", action = picker.grep },
      { icon = " ", key = "fE", desc = "Live GrEp", action = picker.live_grep },
      { icon = " ", key = "r", desc = "Recent Files", action = picker.recent },
      { icon = "󱏒 ", key = "E", desc = "File Explorer", action = ":E" },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "d", desc = "Dotfiles", action = ":lua Snacks.picker.files({ cwd = '~/dotfiles', hidden = true })" },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },
  sections = {
    {
      pane = 1,
      { title = '   nvim ' .. tostring(vim.version()), align = 'center' },
      { section = "keys", gap = 1, padding = 1 },
    },
    {
      pane = 2,
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
    },
  },
}

return M
