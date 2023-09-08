local r = require
---@param source string
---@param opts PluginOptions
return function(source, opts)
  local msg      = r'baggage.msg'
  local plugin   = r'baggage.create_plugin_from_url' (source, opts)

  r'baggage.prepare_opt_directory'(plugin)
  if not vim.uv.fs_stat(plugin.path) then
    r'baggage.within'(r'baggage.settings'.opt_path, function()
      -- using vim.cmd because vim.fn.system also blocks the UI when running synchroneously so we
      -- can't print info messages. But we *have* to run synchrounously because code after the call to
      -- from relies on packages existing.
      vim.cmd("!git submodule add " .. plugin.clone_url .. " " .. plugin.dirname)
      vim.cmd("!git commit -m 'add: " .. plugin.dirname .. "'")
    end)

    r'baggage.within'(plugin.path, function()
      if plugin.commit then
        msg.info("checking out commit %s", plugin.commit)
        vim.cmd("!git checkout " .. plugin.commit)
      end

      if plugin.opts.on_sync then
        if vim.startswith(plugin.opts.on_sync, ":") then
          vim.cmd(plugin.opts.on_sync:sub(2))
        else
          vim.cmd("! " .. plugin.opts.on_sync)
        end
      end

      if vim.uv.fs_stat(plugin.path .. "/doc") then
        vim.cmd("helptags " .. plugin.path .. "/doc")
      end
    end)
  end

  vim.cmd("packadd " .. plugin.dirname)

  return plugin
end
