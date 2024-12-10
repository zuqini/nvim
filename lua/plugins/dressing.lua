return {
  'stevearc/dressing.nvim',
  enabled = false,
  opts = {
    select = {
      -- Priority list of preferred vim.select implementations
      backend = { "fzf_lua", "telescope", "fzf", "builtin", "nui" },
    },
  },
}
