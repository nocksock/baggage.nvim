local M = {}

_G.LOADED_PLUGINS = {}

---@param candidates string[]
local function load_from_canditates(candidates)
  for _,name in ipairs(candidates) do
    local ok, p = pcall(require, name)
    if ok then
      return p
    end
  end
end

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
    return vim.tbl_map(function(o)
      if type(o) == 'table' then
        return M.from(o[1], o[2])
      end
      return M.from(o)
    end, origin)
  end

  if not is_supported(origin) then
    error("Unsupported origin: " .. origin)
  end

  local plugin = require'baggage.from_remote'(origin, opts)

  return {
    load = function(handle)
      local msg = require'baggage.msg'

      if handle then
        return require(handle)
      end

      local candidates = require'baggage.infer_plugin_handle'(plugin.name)
      local p = load_from_canditates(candidates)
      if p then
        table.insert(LOADED_PLUGINS, p)
        return p
      end

      msg.error("could not infer plugin handle for " .. plugin.name .." from url. Tried: " .. vim.inspect(candidates))
      msg.error("provide the handle as parameter to .load(), refer to the docs of " .. plugin.name .. " what the proper handle is.")
      msg.error("the handle is what you pass to the require() function.")
    end
  }

end

return {
  from = M.from
}
