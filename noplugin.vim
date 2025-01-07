lua << EOF
  local vrequire = require("utils").vrequire
  require("plugins.themes.default")
  require("globals")

  vrequire("commands")
  require("commands")

  vrequire("options")
  require("options")

  vrequire("mappings")
  require("mappings")
EOF

set showmode
