return {
  'stevearc/oil.nvim',
  config = function()
    vim.api.nvim_create_user_command('E', ':Oil --float .', { nargs = 0 }) --Edit working directory
    vim.api.nvim_create_user_command('EE', ':Oil --float %:p:h<args>', { nargs = 0 }) --Edit current path
    vim.api.nvim_create_user_command('EC', ':Oil --float %:p:h<args>', { nargs = 0 }) --Edit current path
    vim.api.nvim_create_user_command('ED', ':Oil --float <args>', { nargs = 1 }) --Edit given path
    require("oil").setup({
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
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
      },
    })
  end
}
