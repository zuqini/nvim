local vrequire = require("utils").vrequire

vrequire("options")
vrequire("mappings")
vrequire("commands")
vrequire("neovide")

require("utils.globals")
require("utils.lazy") -- make sure to set `mapleader` before lazy
require("utils.theme-hot-reload")
