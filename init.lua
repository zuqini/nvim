local vrequire = require("utils").vrequire

vrequire("options")
vrequire("mappings")
vrequire("commands")

require("utils.globals")
require("utils.lazy") -- make sure to set `mapleader` before lazy. mapleader is set in mappings
require("utils.theme-hot-reload")

vrequire("neovide")
