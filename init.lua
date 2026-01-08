vim.pack.add({ 'https://github.com/zuqini/zpack.nvim' })
-- vim.pack.add({ { src = 'https://github.com/zuqini/zpack.nvim', version = '89a5a0ce4542a8433b9b7a94621f58e538ed9f01' } })
-- vim.pack.add({ { src = vim.fn.expand('~/projects/zpack.nvim'), version = 'main' } })

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
