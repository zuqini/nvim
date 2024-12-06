return {
  'chentoast/marks.nvim',
  event = "VeryLazy",
  config = function()
    require 'marks'.setup {
      -- whether to map keybinds or not. default true
      default_mappings = true,
      -- which builtin marks to show. default {}
      -- builtin_marks = { ".", "<", ">", "[", "]", "^" },
      -- whether movements cycle back to the beginning/end of buffer. default true
      cyclic = true,
      -- whether the shada file is updated after modifying uppercase marks. default false
      force_write_shada = false,
      -- how often (in ms) to redraw signs/recompute mark positions.
      -- higher values will have better performance but may cause visual lag,
      -- while lower values may cause performance penalties. default 150.
      refresh_interval = 250,
      -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
      -- marks, and bookmarks.
      -- can be either a table with all/none of the keys, or a single number, in which case
      -- the priority applies to all marks.
      -- default 10.
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      -- disables mark tracking for specific filetypes. default {}
      excluded_filetypes = { "", "fzf" },
      bookmark_0 = {
        sign = "0",
      },
      bookmark_1 = {
        sign = "1",
      },
      bookmark_2 = {
        sign = "2",
      },
      bookmark_3 = {
        sign = "3",
      },
      bookmark_4 = {
        sign = "4",
      },
      bookmark_5 = {
        sign = "5",
      },
      bookmark_6 = {
        sign = "6",
      },
      bookmark_7 = {
        sign = "7",
      },
      bookmark_8 = {
        sign = "8",
      },
      bookmark_9 = {
        sign = "9",
      },
    }
  end,
}
