-- also use this for .pcl files
vim.filetype.add({
  extension = {
    pcl = "pkl",
  },
})

-- {"nvim-treesitter/nvim-treesitter"}
-- {"L3MON4D3/LuaSnip"}
return {
  "apple/pkl-neovim",
  cond = not vim.g.vscode,
  ft = 'pkl',
  build = function()
    require('pkl-neovim').init()

    -- Set up syntax highlighting.
    vim.cmd("TSInstall pkl")
  end,
  config = function()
    require('utils').schedule_notify('pkl/pcl loaded')
    -- Set up snippets.
    require("luasnip.loaders.from_snipmate").lazy_load()

    -- Configure pkl-lsp
    -- brew install pkl-lsp
    vim.g.pkl_neovim = {
      start_command = { "pkl-lsp" },
      pkl_cli_path = "/opt/homebrew/bin/pkl-lsp"
    }
  end,
}
