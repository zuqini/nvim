-- also use this for .pcl files
vim.filetype.add({
  extension = {
    pcl = "pkl",
  },
})

-- pkl-neovim ships its snippets in snipmate format. zsnip reads them off the
-- runtimepath under either completion engine -- and since it re-checks the
-- runtimepath on every lookup, this plugin joining it on the pkl filetype is
-- picked up without anything here saying so.
return {
  "apple/pkl-neovim",
  cond = not vim.g.vscode,
  ft = 'pkl',
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  build = function()
    require('pkl-neovim').init()

    -- Set up syntax highlighting.
    vim.cmd("TSInstall pkl")
  end,
  config = function()
    require('utils').schedule_notify('pkl/pcl loaded')

    -- Configure pkl-lsp
    -- brew install pkl-lsp
    vim.g.pkl_neovim = {
      start_command = { "pkl-lsp" },
      pkl_cli_path = "/opt/homebrew/bin/pkl-lsp"
    }
  end,
}
