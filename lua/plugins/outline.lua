return {
  "hedyhli/outline.nvim",
  cond = not vim.g.vscode,
  config = function()
    vim.api.nvim_create_user_command('O', "Outline", { bang = true })
    require("outline").setup {}
  end,
}
