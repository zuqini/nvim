vim.g.is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1

-- 'builtin' is nvim's own completion: buffer words and paths as 'complete'
-- functions under 'autocomplete', with zsnip's snippet source and the LSP
-- omnifunc alongside them in the same ranked menu.
--
-- Falling back rather than trusting the variable: an unknown name matches
-- neither branch, which leaves nvim with no completion engine at all and
-- nothing said about why. The names have already changed twice.
local CMP_ENGINES = { blink = true, builtin = true }
local requested = vim.env.NVIM_CMP_ENGINE
vim.g.cmp_engine = CMP_ENGINES[requested] and requested or 'builtin' -- blink | builtin
if requested and not CMP_ENGINES[requested] then
  vim.schedule(function()
    local msg = ("NVIM_CMP_ENGINE=%q is not a completion engine; using 'builtin'"):format(requested)
    vim.notify(msg, vim.log.levels.WARN)
  end)
end
vim.g.ui_engine = 'ui2'      -- ui2 | noice
vim.g.hybrid_nu = true
vim.g.transparent_background = true
vim.g.transparent_float_if_transparent = false
vim.g.virtual_line_current_line = true

_G.clear_floats_and_highlights = function()
  vim.cmd [[ nohlsearch ]]
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local success, config = pcall(vim.api.nvim_win_get_config, win)
    if not success then
      return
    end

    if config.relative ~= "" then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end
end
