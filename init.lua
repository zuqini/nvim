local vrequire = require("utils").vrequire

require("globals")

vrequire("options")
vrequire("mappings")
vrequire("commands")

require("options")
require("mappings")
require("commands")

require("utils.lazy") -- make sure to set `mapleader` before lazy. mapleader is set in mappings
require("utils.theme-hot-reload")

vrequire("neovide")
