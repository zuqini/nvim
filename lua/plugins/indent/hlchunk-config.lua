local normal_hl = "#00FF00"
local error_hl = "#FF0000"
local indent_hl_list = {
  "#662121",
  "#767621",
  "#216631",
  "#325a5e",
  "#324b7b",
  "#562155",
}

require("hlchunk").setup({
  chunk = {
    enable = true,
    style = {
      normal_hl,
      error_hl,
    },
    -- animation related
    duration = 0,
    delay = 0,
  },
  indent = {
    enable = true,
    style = indent_hl_list,
  },
  line_num = {
    enable = true,
    style = {
      "#00FF00"
    },
  },
  blank = {
    -- https://github.com/shellRaining/hlchunk.nvim/issues/123
    -- blank doesn't seem to work. Disable for now.
    enable = false,
  },
})
