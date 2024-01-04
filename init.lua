local vrequire = require("utils").vrequire

require("utils.globals") -- globals
require("utils.lazy") -- plugin manager
require("utils.theme-hot-reload") -- hot reload

vrequire("options")
vrequire("mappings")
vrequire("commands")

vrequire("neovide") -- client specific configs
