vim.pack.add({ 'https://github.com/zuqini/zpack.nvim' })
-- vim.pack.add({ { src = 'https://github.com/zuqini/zpack.nvim', version = 'b331e1dda54511085a778d2881dd246b8ed58800' } }) --module-loader improved
-- vim.pack.add({ { src = 'https://github.com/zuqini/zpack.nvim', version = 'e1ade688803bbfc9844a3b7388d5098cfe6ede5b' } }) --module-loader
-- vim.pack.add({ { src = 'https://github.com/zuqini/zpack.nvim', version = 'bebe7929b224a2df7f76a22d441cee21c845fabd' } }) --pre-module-loader
-- vim.pack.add({ { src = vim.fn.expand('~/projects/zpack.nvim'), version = 'main' } })

local vrequire = require("utils").vrequire

require("globals")

vrequire("utils")

vrequire("commands")
require("commands")

vrequire("mappings")
require("mappings")

require('zpack').setup({
  profiling = {
    loader = true,
    require = true,
  }
})

vrequire("options")
require("options")

require("utils.theme")

vrequire("neovide")
require("vsc-config")
