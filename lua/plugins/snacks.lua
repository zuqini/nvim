return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = {},
    quickfile = {},
    picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },
      layout = {
        layout = {
          width = 0.85,
          min_width = 80,
          height = 0.95,
          min_height = 30,
          box = "vertical",
          -- border = "rounded",
          title = "{source} {live}",
          title_pos = "center",
          { win = "preview", height = 0.5,   border = "none" },
          { win = "input",   height = 1,     border = "none" },
          { win = "list",    border = "none" },
        },
      },
    },
  },
  keys = {
    -- find
    { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end,                                                   desc = "Find Files" },
    { "<leader>fF", function() Snacks.picker.files({ hidden = true, ignored = true }) end,                                   desc = "Find Files (Ignored)" },
    { "<leader>fb", function() Snacks.picker.buffers() end,                                                                  desc = "Buffers" },
    { "<leader>fd", function() Snacks.picker.files({ cwd = '~/dotfiles' }) end,                                              desc = "Find Dots" },
    { "<leader>fg", function() Snacks.picker.git_files() end,                                                                desc = "Find Git Files" },
    { "<leader>fr", function() Snacks.picker.recent() end,                                                                   desc = "Recent" },
    -- git
    { "<leader>,c", function() Snacks.picker.git_log() end,                                                                  desc = "Git Log" },
    { "<leader>,s", function() Snacks.picker.git_status() end,                                                               desc = "Git Status" },
    -- Grep
    { "<leader>fn", function() Snacks.picker.grep({ hidden = true, live = false, need_search = false }) end,                 desc = "Grep" },
    { "<leader>fN", function() Snacks.picker.grep({ hidden = true }) end,                                                    desc = "Live Grep" },
    { "<leader>fi", function() Snacks.picker.grep({ hidden = true, ignored = true, live = false, need_search = false }) end, desc = "Grep (Ignored)" },
    { "<leader>fI", function() Snacks.picker.grep({ hidden = true, ignored = true }) end,                                    desc = "Live Grep (Ignored)" },
    { "<leader>fl", function() Snacks.picker.lines() end,                                                                    desc = "Buffer Lines" },
    { "<leader>fN", function() Snacks.picker.grep_buffers() end,                                                             desc = "Grep Open Buffers" },
    { "<leader>fw", function() Snacks.picker.grep_word() end,                                                                desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>f"', function() Snacks.picker.registers() end,                                                                desc = "Registers" },
    { "<leader>fa", function() Snacks.picker.autocmds() end,                                                                 desc = "Autocmds" },
    { "<leader>f;", function() Snacks.picker.command_history() end,                                                          desc = "Command History" },
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
  },
}
