lua << EOF
  local vrequire = require("utils").vrequire
  require("globals")

  vrequire("options")
  vrequire("mappings")
  vrequire("commands")

  require("options")
  require("mappings")
  require("commands")
EOF

colorscheme habamax
set showmode
