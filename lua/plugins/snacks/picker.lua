local M = {}

-- copied from documentation + adjustments
local layout_main = {
  reverse = true,
  layout = {
    width = 0.85,
    height = 0.95,
    box = "vertical",
    title = "{source} {live}",
    title_pos = "center",
    { win = "list",    border = "none" },
    { win = "input",   height = 1,     border = "none" },
    { win = "preview", height = 0.55,  border = "top" },
  },
}

-- copied from documentation
local layout_ivy_lines = {
  preview = 'main',
  reverse = true,
  layout = {
    box = "vertical",
    backdrop = false,
    row = -1,
    width = 0,
    height = 0.4,
    border = "top",
    title = " {source} {live}",
    title_pos = "left",
    {
      box = "horizontal",
      { win = "list",    border = "top" },
      { win = "preview", width = 0.6,   border = "left" },
    },
    { win = "input", height = 1, border = "none" },
  },
}

-- result of trial and error, not really sure how this layout works
local layout_vscode = {
  preview = false,
  reverse = false,
  layout = {
    box = "vertical",
    width = 0.4,
    min_width = 80,
    height = 0.4,
    border = "none",
    title = "{source} {live}",
    title_pos = "center",
    { win = "preview", border = "none" },
    { win = "input",   height = 1,     border = "none" },
    { win = "list",    border = "none" },
  },
}


M.opts = {
  formatters = {
    file = {
      filename_first = true,
    },
  },
  layout = layout_main,
}

M.keys = {
  -- find
  { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end,                                                   desc = "Find Files" },
  { "<leader>fF", function() Snacks.picker.files({ hidden = true, ignored = true }) end,                                   desc = "Find Files (Ignored)" },
  { "<leader>fb", function() Snacks.picker.buffers() end,                                                                  desc = "Buffers" },
  { "<leader>fd", function() Snacks.picker.files({ cwd = '~/dotfiles', hidden = true }) end,                               desc = "Find Dots" },
  { "<leader>fr", function() Snacks.picker.recent() end,                                                                   desc = "Recent" },
  -- git
  { "<leader>,c", function() Snacks.picker.git_log_file() end,                                                             desc = "Git Log File (Commits)" },
  { "<leader>,l", function() Snacks.picker.git_log() end,                                                                  desc = "Git Log" },
  { "<leader>,d", function() Snacks.picker.git_diff() end,                                                                 desc = "Git Diff" },
  { "<leader>,s", function() Snacks.picker.git_status() end,                                                               desc = "Git Status" },
  { "<leader>,f", function() Snacks.picker.git_files() end,                                                                desc = "Git Files" },
  -- Grep
  { "<leader>fe", function() Snacks.picker.grep({ hidden = true, live = false, need_search = false }) end,                 desc = "GrEp" },
  { "<leader>fE", function() Snacks.picker.grep({ hidden = true }) end,                                                    desc = "Live GrEp" },
  { "<leader>fi", function() Snacks.picker.grep({ hidden = true, ignored = true, live = false, need_search = false }) end, desc = "Grep (Ignored)" },
  { "<leader>fI", function() Snacks.picker.grep({ hidden = true, ignored = true }) end,                                    desc = "Live Grep (Ignored)" },
  { "<leader>fl", function() Snacks.picker.lines({ layout = layout_ivy_lines, }) end,                                      desc = "Buffer Lines" },
  { "<leader>fN", function() Snacks.picker.grep_buffers() end,                                                             desc = "Grep Open Buffers" },
  { "<leader>fw", function() Snacks.picker.grep_word() end,                                                                desc = "Visual selection or word", mode = { "n", "x" } },
  -- search
  { '<leader>f"', function() Snacks.picker.registers() end,                                                                desc = "Registers" },
  { "<leader>fa", function() Snacks.picker.autocmds() end,                                                                 desc = "Autocmds" },
  { "<leader>f;", function() Snacks.picker.command_history({ layout = layout_vscode }) end,                                desc = "Command History" },
  { "<leader>f:", function() Snacks.picker.commands() end,                                                                 desc = "Commands" },
  { "<leader>ld", function() Snacks.picker.diagnostics() end,                                                              desc = "Diagnostics" },
  { "<leader>fh", function() Snacks.picker.help() end,                                                                     desc = "Help Pages" },
  { "<leader>fH", function() Snacks.picker.highlights() end,                                                               desc = "Highlights" },
  { "<leader>fj", function() Snacks.picker.jumps() end,                                                                    desc = "Jumps" },
  { "<leader>fk", function() Snacks.picker.keymaps() end,                                                                  desc = "Keymaps" },
  { "<leader>fx", function() Snacks.picker.loclist() end,                                                                  desc = "Location List" },
  { "<leader>fM", function() Snacks.picker.man() end,                                                                      desc = "Man Pages" },
  { "<leader>fm", function() Snacks.picker.marks() end,                                                                    desc = "Marks" },
  { "<leader>fR", function() Snacks.picker.resume() end,                                                                   desc = "Resume" },
  { "<leader>fc", function() Snacks.picker.qflist() end,                                                                   desc = "Quickfix List" },
  { "<leader>fC", function() Snacks.picker.colorschemes() end,                                                             desc = "Colorschemes" },
  { "<leader>fp", function() Snacks.picker.projects() end,                                                                 desc = "Projects" },
  -- LSP
  { "<leader>ld", function() Snacks.picker.lsp_definitions() end,                                                          desc = "Goto Definition" },
  { "<leader>lr", function() Snacks.picker.lsp_references() end,                                                           nowait = true,                     desc = "References" },
  { "<leader>li", function() Snacks.picker.lsp_implementations() end,                                                      desc = "Goto Implementation" },
  { "<leader>lD", function() Snacks.picker.lsp_type_definitions() end,                                                     desc = "Goto T[y]pe Definition" },
  { "<leader>ls", function() Snacks.picker.lsp_symbols() end,                                                              desc = "LSP Symbols" },
}
return M
