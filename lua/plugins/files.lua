return {
  {
    'echasnovski/mini.files',
    version = false,
    config = function()
      require('mini.files').setup({
        mappings = {
          go_in       = 'L',
          go_in_plus  = '<CR>',
          go_out      = 'H',
          go_out_plus = '<ESC>',
        },
        windows = {
          preview = true,
        },
      })
      vim.api.nvim_create_user_command('E', ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0))', { nargs = 0 }) --Edit current path
      vim.api.nvim_create_user_command('EE', ':lua MiniFiles.open(nil, false)', { nargs = 0 })                            --Edit current path
    end
  },
  {
    'stevearc/oil.nvim',
    enabled = false,
    config = function()
      vim.api.nvim_create_user_command('E', ':Oil %:p:h', { nargs = 0 })   --Edit current path
      vim.api.nvim_create_user_command('EE', ':Oil .', { nargs = 0 })      --Edit working directory
      vim.api.nvim_create_user_command('ED', ':Oil <args>', { nargs = 1 }) --Edit given path
      require("oil").setup({
        columns = {
          -- "type",
          "permissions",
          "size",
          -- "ctime",
          "mtime",
          -- "atime",
          -- "birthtime",
          "icon",
        },
        view_options = {
          show_hidden = true,
        },
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
              clear_floats_and_highlights();
              require("oil.actions").refresh.callback();
            end,
            mode = "n"
          },
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["g."] = "actions.toggle_hidden",
        },
      })
    end
  }
}
