local r = require
---@param plugin Plugin
return function(plugin)
  if type(plugin.opts.on_sync) == 'string' and vim.startswith(plugin.opts.on_sync, ":") then
    vim.cmd(plugin.opts.on_sync:sub(2))
    r'baggage.events'.trigger("SyncSuccess", plugin)
    r'baggage.msg'.info("Successfully executed `on_sync` for `%s`.", plugin.name)
  else
    r'baggage.system'(plugin.opts.on_sync, function(result)
      if result.code ~= 0 then
        r'baggage.msg'.error("Failed to execute sync routine for `%s`.", plugin.name)
      end
      r'baggage.msg'.info("Successfully executed `on_sync` for `%s`.", plugin.name)
    end, {
      cmd = {
        cwd = plugin.path,
      },
    })
  end
end
