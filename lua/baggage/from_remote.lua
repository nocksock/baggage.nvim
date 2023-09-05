---@param source string
---@param plugin_opts PluginOptions
return function(source, plugin_opts)
  local settings = require'baggage.settings'
  local msg      = require'baggage.msg'
  local system   = require'baggage.system'
  local plugin   = require'baggage.extract_source_info' (source)

  plugin.remote = true
  plugin.opts = plugin_opts or {}
  plugin.dirname = plugin.org .. "-" .. plugin.name
  plugin.path = settings.pack_path .. plugin.dirname

  if not vim.uv.fs_stat(plugin.path) then
    msg.info("cloning %s", plugin.clone_url)
    system({ "git", "clone", plugin.clone_url, plugin.path }, function(result)
      if result.code ~= 0 then
        error("Failed to clone plugin repository: %s", vim.inspect(result))
      end

      if plugin.commit then
        msg.info("checking out commit %s", plugin.commit)
        system({ "git", "checkout", plugin.commit })
      end
    end)

    vim.cmd("helptags ALL")
    vim.cmd("packadd! " .. plugin.dirname)
  end

  if plugin.opts.on_sync then
    require'baggage.run_sync'(plugin, plugin_opts)
  end

  return plugin
end
