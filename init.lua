local vrequire = require("utils").vrequire

require("globals")

vrequire("utils")

vrequire("commands")
require("commands")

vrequire("mappings")
require("mappings")

if vim.g.vscode then
  require("vsc-config")
end

require("utils.pack").import_specs_from_dir('plugins')

vrequire("options")
require("options")

require("utils.theme")

vrequire("neovide")
