local r = require
---@class SourceInfo
---@field name string
---@field org string
---@field clone_url string
---@field commit string

---@class Plugin :SourceInfo
---@field path string
---@field opts PluginOptions

---@class PluginOptions
---@field on_sync string | fun()

---@param remote_url string
---@param opts PluginOptions
return function(source, opts)
  local settings = r'baggage.settings'
  local msg      = r'baggage.msg'
  local system   = r'baggage.system'
  local plugin   = r'baggage.extract_source_info' (source)

  plugin.opts = opts or {}
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

    if plugin.opts.on_sync then
      r'baggage.run_sync'(plugin)
    end
  end

  return plugin
end
