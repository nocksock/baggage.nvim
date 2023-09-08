local M = {}


_G.LOADED_PLUGINS = {}
local r = require

---comment
---@param origin string
---@return boolean
local is_supported = function(origin)
  return vim.startswith(origin, "https://")
end

---comment
---@param origin string|(string|table)[]
---@param opts? PluginOptions
---@return table
M.from = function(origin, opts)
  if type(origin) == 'table' then
    local plugins = vim.tbl_map(function(o)
      if type(o) == 'table' then
        return M.from(o[1], o[2])
      end
      return M.from(o)
    end, origin)
    -- return the last for chaining with .load
    return plugins[#plugins]
  end

  if not is_supported(origin) then
    error("Unsupported origin: " .. origin)
  end

  local plugin = r'baggage.from_remote'(origin, opts or {})

  return {
    load = r'baggage.load'(plugin),
  }
end

return {
  from = M.from
}
