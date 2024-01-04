local tree_cb = require'nvim-tree.config'.nvim_tree_callback

-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
require'nvim-tree'.setup {
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {
        { key = "s", cb = ":lua leap_all_windows()<CR>" },
        { key = "<c-s>", cb = tree_cb("system_open") },
      }
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<s-tab>', ':NvimTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n', '<c-n>', ':NvimTreeFindFile<Cr>', opts)
