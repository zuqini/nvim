-- disable nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- detect if is windows
vim.g.is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1

_G.close_all_float = function ()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win);
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, false);
        end
    end
end

-- Searching in all windows (including the current one) on the tab page.
_G.leap_all_windows = function ()
  require('leap').leap { target_windows = vim.tbl_filter(
    function (win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0)
  )}
end

-- Bidirectional search in the current window is just a specific case of the
-- multi-window mode.
_G.leap_bidirectional = function ()
  require('leap').leap { target_windows = { vim.fn.win_getid() } }
end
