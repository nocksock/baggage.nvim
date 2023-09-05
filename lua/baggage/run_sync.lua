---@class SourceInfo
---@field name string
---@field org string
---@field clone_url string
---@field commit string
---
---@class PluginSpec :SourceInfo
---@field path string
---@field opts PluginOptions

---@class PluginOptions
---@field on_sync string | fun()

---comment
---@param plugin PluginSpec
---@param plugin_opts PluginOptions
return function(plugin, plugin_opts)
  if vim.startswith(plugin_opts.on_sync, ":") then
    plugin.on_sync = function()
      vim.cmd(plugin_opts.on_sync:sub(2))
      require'baggage.events'.trigger("SyncSuccess", plugin)
      require'baggage.msg'.info("Successfully executed `on_sync` for `%s`.", plugin.name)
    end
  else
    plugin.on_sync = function()
      require'baggage.system'(plugin_opts.on_sync, function(result)
        if result.code ~= 0 then
           require'baggage.msg'.error("Failed to execute sync routine for `%s`.", plugin.name)
        end
        require'baggage.msg'.info("Successfully executed `on_sync` for `%s`.", plugin.name)
      end, {
        cmd = {
          cwd = plugin.path,
        },
      })
    end
  end
end
