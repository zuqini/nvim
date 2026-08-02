-- also use this for .pcl files
vim.filetype.add({
  extension = {
    pcl = "pkl",
  },
})

-- pkl-neovim ships its snippets in snipmate format. Under the builtin engine
-- cmp-sources reads them off the runtimepath itself, so luasnip is only needed
-- to load them under blink -- and nothing else in this config pulls it in.
local use_luasnip = vim.g.cmp_engine == 'blink'

local dependencies = { "nvim-treesitter/nvim-treesitter" }
if use_luasnip then
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
    if use_luasnip then
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
