vim.g.is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct
require("lazy").setup('plugins', {
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock" .. (vim.g.is_windows and '.win' or '') .. ".json",
})

local vrequire = require("utils").vrequire

require("utils.globals") -- sets up _G functions
require("utils.themes-hot-reload")
vrequire("main")
vrequire("neovide") -- client specific configs
