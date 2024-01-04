return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v2.x",
  keys = {
    "<S-Tab>",
    "<Leader><Tab>",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    local opts = { noremap=true, silent=true }
    vim.api.nvim_set_keymap('n', '<S-tab>', ':NeoTreeFocusToggle<CR>', opts)
    vim.api.nvim_set_keymap('n', '<leader><tab>', ':NeoTreeRevealToggle<CR>', opts)
    require("neo-tree").setup({
      close_if_last_window = true,
      window = {
        mappings = {
        }
      },
    })
  end
}

