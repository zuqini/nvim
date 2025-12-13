---@class KeySpec
---@field [1] string
---@field [2]? fun()
---@field noremap? boolean
---@field desc? string
---@field mode? string|string[]
---@field nowait? boolean

---@class Spec
---@field [1] string Plugin short name (e.g., "user/repo")
---@field url? string
---@field init? fun()
---@field build? string|fun()
---@field enabled? boolean|(fun():boolean)
---@field cond? boolean|(fun():boolean)
---@field lazy? boolean
---@field version? string
---@field keys? KeySpec|KeySpec[]
---@field config? fun()
---@field event? string|string[]
---@field pattern? string|string[]
---@field cmd? string|string[]
---@field nargs? string
---@field range? boolean
---@field bang? boolean
---@field complete? string
---@field count? boolean

---@class PackLoadParam
---@field spec vim.pack.Spec
---@field path string

return {}
