local vrequire = require("utils").vrequire

require("globals")

vrequire("utils")

vrequire("commands")
require("commands")

vrequire("options")
require("options")

vrequire("mappings")
require("mappings")

require("utils.lazy") -- make sure to set `mapleader` before lazy. mapleader is set in mappings
require("utils.theme-hot-reload")

vrequire("neovide")
