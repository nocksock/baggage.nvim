local M = {}

if _G.r and _G.r ~= require then
  vim.health.warn("r is already defined and not aliased to require")
elseif not vim.g.baggage_no_alias then
  _G.r = require
end

_G.LOADED_PLUGINS = {}

---comment
---@param origin string
---@return boolean
local is_supported = function(origin)
  return vim.startswith(origin, "https://")
end

---comment
---@param origin string|(string|table)[]
---@param opts? PluginOptions
---@return Handle
M.from = function(origin, opts)
  if type(origin) == 'table' then
    local plugins = vim.tbl_map(function(o)
      if type(o) == 'table' then
        return M.from(o[1], o[2])
      end
      return M.from(o)
    end, origin)
    -- return a handle with the last plugin of the list closed in.
    return plugins[#plugins]
  end

  if not is_supported(origin) then
    error("Unsupported origin: " .. origin)
  end

  local plugin = r'baggage.from_remote'(origin, opts)
  return r'baggage.to_handle'(plugin)
end

return {
  from = M.from
}
