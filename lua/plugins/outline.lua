return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen", "O" },
  config = function ()
    vim.api.nvim_create_user_command('O', "Outline", { bang = true })
    require("outline").setup {}
  end,
}
