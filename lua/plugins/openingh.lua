return {
  "almo7aya/openingh.nvim",
  keys = { "<leader>gH", "<leader>gh", },
  config = function ()
    -- for repository page
    vim.api.nvim_set_keymap("n", "<Leader>gH", ":OpenInGHRepo<CR>", { noremap = true })

    -- for current file page
    vim.api.nvim_set_keymap("n", "<Leader>gh", ":OpenInGHFile<CR>", { noremap = true })

    require('which-key').register({
      g = {
        h = 'Open GH file',
        H = 'Open GH repo',
      }
    }, { prefix='<leader>' })
  end
}
