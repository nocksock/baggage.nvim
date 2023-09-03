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

M.from = function(origin, opts)
  if not vim.startswith(origin, "https://") then
    error("Unsupported origin: " .. origin)
  end

  local plugin = require("baggage.core").from_remote(origin, opts)
  local fn = require("baggage.fn")

  return {
    load = function(handle)
      if handle then
        return require(handle)
      end

      local candidates = fn.create_plugin_candidates(plugin.name)
      local p = load_from_canditates(candidates)
      if p then
        table.insert(LOADED_PLUGINS, p)
        return p
      end

      fn.error("could not infer plugin handle for " .. plugin.name .." from url. Tried: " .. vim.inspect(candidates))
      fn.error("provide the handle as parameter to .load(), refer to the docs of " .. plugin.name .. " what the proper handle is.")
      fn.error("the handle is what you pass to the require() function.")
    end
  }

end

return {
  from = M.from
}
