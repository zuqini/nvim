-- also use this for .pcl files
vim.filetype.add({
  extension = {
    pcl = "pkl",
  },
})

-- pkl-neovim ships its snippets in snipmate format, which only luasnip reads.
-- The builtin engine discovers vscode-format packages through a package.json
-- and pkl-neovim has none, so under it there is nothing here to load -- and
-- nothing else pulls luasnip in either.
local snipmate = vim.g.cmp_engine == 'blink'

local dependencies = { "nvim-treesitter/nvim-treesitter" }
if snipmate then
  dependencies[#dependencies + 1] = "L3MON4D3/LuaSnip"
end

return {
  "apple/pkl-neovim",
  cond = not vim.g.vscode,
  ft = 'pkl',
  dependencies = dependencies,
  build = function()
    require('pkl-neovim').init()

    -- Set up syntax highlighting.
    vim.cmd("TSInstall pkl")
  end,
  config = function()
    require('utils').schedule_notify('pkl/pcl loaded')
    if snipmate then
      require("luasnip.loaders.from_snipmate").lazy_load()
    end

    -- Configure pkl-lsp
    -- brew install pkl-lsp
    vim.g.pkl_neovim = {
      start_command = { "pkl-lsp" },
      pkl_cli_path = "/opt/homebrew/bin/pkl-lsp"
    }
  end,
}
