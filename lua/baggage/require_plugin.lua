---@param candidates string[]
local function load_from_canditates(candidates)
  for _,name in ipairs(candidates) do
    local ok, p = pcall(require, name)
    if ok then
      return p, name
    end
  end
end

---@param plugin Plugin
---@overload fun(plugin: string)
return function(plugin)
  local msg = require 'baggage.msg'

  if type(plugin) == "string" then
    return require(plugin), plugin
  end

  assert(type(plugin) == "table", "plugin must be a string or table")

  local candidates = require 'baggage.infer_plugin_handle'(plugin)
  local p, name = load_from_canditates(candidates)

  if not p then
    msg.error("could not infer plugin handle for " .. plugin.name .. " from url. Tried: " .. vim.inspect(candidates))
    msg.error("provide the handle as parameter to .load(), refer to the docs of " ..  plugin.name .. " what the proper handle is.")
    msg.error("the handle is what you pass to the require() function.")
    return
  end

  return p, name
end
