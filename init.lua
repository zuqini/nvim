vim.pack.add({ 'https://github.com/zuqini/zpack.nvim' })

local vrequire = require("utils").vrequire

require("globals")

vrequire("utils")

vrequire("commands")
require("commands")

vrequire("mappings")
require("mappings")

require('zpack').setup()

vrequire("options")
require("options")

require("utils.theme")

vrequire("neovide")
require("vsc-config")
