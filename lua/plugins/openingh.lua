return {
  "almo7aya/openingh.nvim",
  config = function ()
    local map = function(mode, mapping, rhs, desc)
      vim.keymap.set(mode, mapping, rhs, { desc = desc, noremap = true, silent = true })
    end
    -- for repository page
    map("n", "<Leader>gH", ":OpenInGHRepo<CR>", 'Open Repo')
    -- for current file page
    map("n", "<Leader>gh", ":OpenInGHFile<CR>", 'Open Repo File')
  end
}
