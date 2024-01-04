return {
  'nvim-tree/nvim-tree.lua', -- https://github.com/kyazdani42/nvim-tree.lua/issues/877,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    "<S-Tab>",
    "<Leader><Tab>",
  },
  config = function()
    local tree_cb = require'nvim-tree.config'.nvim_tree_callback

    -- following options are the default
    -- each of these are documented in `:help nvim-tree.OPTION_NAME`
    require('nvim-tree').setup({
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      view = {
        mappings = {
          custom_only = false,
          list = {
            { key = "S", cb = ":lua require'fzf-lua'.files()<CR>" },
            { key = "s", cb = ":lua leap_all_windows()<CR>" },
            { key = "<c-s>", cb = tree_cb("system_open") },
          }
        },
      },
    })

    local opts = { noremap=true, silent=true }
    vim.api.nvim_set_keymap('n', '<s-tab>', ':NvimTreeToggle<CR>', opts)
    vim.api.nvim_set_keymap('n', '<leader><tab>', ':NvimTreeFindFileToggle!<CR>', opts)
  end,
}
