vim.pack.add({ 'https://github.com/zuqini/zpack.nvim' })
-- vim.pack.add({ { src = vim.fn.expand('~/projects/zpack.nvim'), version = 'main' } })

local vrequire = require("utils").vrequire

require("globals")

vrequire("utils")

vrequire("commands")
require("commands")

vrequire("mappings")
require("mappings")

require('zpack').setup()

-- testing add after setup
local typr_cmd = {
  "Typr", "TyprStats"
}
require('zpack').add({
  {
    'nvzone/volt',
    cmd = typr_cmd,
    keys = '<leader>a',
    priority = 1000,
    config = function()
      print("volt loaded")
    end
  },
  {
    'nvzone/typr',
    cmd = typr_cmd,
    keys = { '<leader>a', ":Typr<CR>" },
    config = function()
      print("typr loaded")
      require('typr').setup({ mode = "phrases", kblayout = "colemak_dh" })
    end
  },
})

vrequire("options")
require("options")

require("utils.theme")

vrequire("neovide")
require("vsc-config")
