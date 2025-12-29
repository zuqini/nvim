return {
  'stevearc/oil.nvim',
  enabled = true,
  cond = not vim.g.vscode,
  opts = {
    default_file_explorer = true,
    columns = { "permissions", "size", "mtime", "icon" },
    view_options = { show_hidden = true },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = {
        callback = function()
          clear_floats_and_highlights()
          require("oil.actions").refresh.callback()
        end,
        mode = "n"
      },
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["g."] = "actions.toggle_hidden",
    },
  },
  config = function(_, opts)
    vim.api.nvim_create_user_command('E', ':Oil %:p:h', { nargs = 0 })
    vim.api.nvim_create_user_command('EE', ':Oil .', { nargs = 0 })
    vim.api.nvim_create_user_command('ED', ':Oil <args>', { nargs = 1 })
    require("oil").setup(opts)
  end
}
