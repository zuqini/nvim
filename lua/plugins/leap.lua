return {
  'ggandor/leap.nvim', -- breaking changes: https://github.com/ggandor/leap.nvim/issues/18
  event = 'VeryLazy',
  config = function ()
    require('leap').setup{
      highlight_unlabeled_phase_one_targets = true,
    }

    -- leap_all_windows defined in helpers.lua and used nvim-tree.lua
    vim.keymap.set('x', 's', leap_all_windows, { silent = true })
    vim.keymap.set('v', 's', leap_all_windows, { silent = true })
    vim.keymap.set('n', 's', leap_all_windows, { silent = true })

    require('which-key').register({
      s = 'Search (Leap)'
    })

    -- custom highlights
    -- local function leap_highlight()
    --   vim.api.nvim_set_hl(0, 'LeapMatch', { fg = "#ccff88", ctermfg = "red", underline = true })
    --   vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { fg = "black", bg = "#ff8877", ctermfg = "black", ctermbg = "red" })
    --   vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { fg = "black", bg = "#99ccff", ctermfg = "black", ctermbg = "blue" })
    -- end

    -- leap_highlight()
    -- vim.api.nvim_create_autocmd("ColorScheme", {
    --   pattern = "*",
    --   callback = leap_highlight,
    -- })
  end
}
