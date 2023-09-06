---@param candidates string[]
local function load_from_canditates(candidates)
  for _,name in ipairs(candidates) do
    local ok, p = pcall(require, name)
    if ok then
      return p
    end
  end
end

return function(plugin)
  return function(handle)
    local msg = require 'baggage.msg'

    if handle then
      return require(handle)
    end

    local candidates = require 'baggage.infer_plugin_handle' (plugin.name)
    local p = load_from_canditates(candidates)
    if p then
      table.insert(LOADED_PLUGINS, p)
      return p
    end

    msg.error("could not infer plugin handle for " .. plugin.name .. " from url. Tried: " .. vim.inspect(candidates))
    msg.error("provide the handle as parameter to .load(), refer to the docs of " ..
    plugin.name .. " what the proper handle is.")
    msg.error("the handle is what you pass to the require() function.")
  end
end
