return {
  'stevearc/dressing.nvim',
  opts = {
    select = {
      -- Priority list of preferred vim.select implementations
      backend = { "fzf_lua", "telescope", "fzf", "builtin", "nui" },
    },
  },
}
