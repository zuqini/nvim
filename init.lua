local vrequire = require("utils").vrequire

vrequire("options")
vrequire("mappings")
vrequire("commands")
vrequire("neovide") -- client specific configs

require("utils.globals") -- globals
require("utils.lazy") -- plugin manager
require("utils.theme-hot-reload") -- hot reload
