local M ={}

local event = require("baggage.events")

---comment
---@param plugin PluginSpec
event.on("ClonePost", function(plugin)
    if plugin.opts.on_sync and type(plugin.opts.on_sync) == "string" then
        M.run_sync(plugin, plugin.opts)
    else
        plugin.on_sync = plugin.opts.on_sync
    end
end)

return M
