return {
  'stevearc/dressing.nvim',
  opts = {
    input = {
      -- When true, <Esc> will close the modal - Defaults to true
      insert_only = false,
    },
    select = {
      -- Priority list of preferred vim.select implementations
      backend = { "fzf_lua", "telescope", "fzf", "builtin", "nui" },
    },
  },
}
