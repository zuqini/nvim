return {
  "hedyhli/outline.nvim",
  cond = not vim.g.vscode,
  cmd = { 'O', 'Outline', 'OutlineOpen' },
  opts = {},
  config = function(_, opts)
    vim.api.nvim_create_user_command('O', "Outline", { bang = true })
    require("outline").setup(opts)
  end,
}
