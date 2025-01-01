lua << EOF
  local vrequire = require("utils").vrequire
  require("globals")

  vrequire("commands")
  require("commands")

  vrequire("options")
  require("options")

  vrequire("mappings")
  require("mappings")
EOF

colorscheme retrobox
set showmode
