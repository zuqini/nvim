local M = {}

M.debug = false

M.lazy_group = vim.api.nvim_create_augroup('LazyPack', { clear = true })
M.startup_group = vim.api.nvim_create_augroup('StartupPack', { clear = true })

---@type vim.pack.Spec[]
M.startup_packs = {}
---@type vim.pack.Spec[]
M.lazy_packs = {}
---@type KeySpec[]
M.startup_keys = {}
---@type { [string]: Spec }
M.src_spec = {}
---@type { [string]: boolean }
M.src_to_request_build = {}
---@type string[]
M.src_with_startup_init = {}
---@type string[]
M.src_with_startup_config = {}

return M
