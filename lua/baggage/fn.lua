local M = {}
local if_nil = vim.F.if_nil

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

M.trace = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.TRACE)
end

M.debug = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.DEBUG)
end

M.info = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.INFO)
end

M.warn = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.WARN)
end

M.error = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.ERROR)
end

---@param command string | string[] List of command arguments
---@param callback fun(result: table)? Callback to run once the command finishes
---@param opts { sync: boolean?, ignore_errors: boolean?, error_msg: string?, cmd: systemOpts? }? Extra options
---@return systemCompleted? result Will only be returned if `opts.sync` was `true`
function M.system(command, callback, opts)
  opts = if_nil(opts, {})
  opts.sync = if_nil(opts.sync, true)
  opts.ignore_errors = if_nil(opts.ignore_errors, false)
  opts.cmd = if_nil(opts.cmd, {})

  if type(command) == "string" then
    command = { command }
  end

  local cmd_opts = vim.tbl_deep_extend("force", { text = true }, opts.cmd)

  local result = vim.system(command, cmd_opts, vim.schedule_wrap(function(result)
    if (not opts.ignore_errors) and result.code ~= 0 then
      local message = opts.error_msg or "Failed to run shell command"
      vim.error(message .. ": %s", vim.inspect(result))
      return
    end

    if callback then
      callback(result)
    end
  end))

  if opts.sync then
    return result:wait()
  end
end

---@param source string any url with a basic format similar to gitlab/sourcehut/github etc
---@return PluginSpec
function M.extract_source_info(source)
  local host, org, name = source:match("https://([^/]+)/([^/]+)/([^/]+)/?")
  local commit = source:match("/tree/([^/]+)$")

  return {
    clone_url = "https://" .. host .. "/" .. org .. "/" .. name,
    name = name,
    org = org,
    commit = commit
  }
end

function M.run_sync(plugin, plugin_opts)
  if vim.startswith(plugin_opts.on_sync, ":") then
    plugin.on_sync = function()
      vim.cmd(plugin_opts.on_sync:sub(2))
      M.trigger("SyncSuccess", plugin)
      M.info("Successfully executed `on_sync` for `%s`.", plugin.name)
    end
  else
    plugin.on_sync = function()
      M.system(plugin_opts.on_sync, function(result)
        if result.code ~= 0 then
          M.error("Failed to execute sync routine for `%s`.", plugin.name)
        end

        M.info("Successfully executed `on_sync` for `%s`.", plugin.name)
      end, {
        cmd = {
          cwd = plugin.path,
        },
      })
    end
  end
end

---@param plugin_slug string
---@return string[]
function M.create_plugin_candidates(plugin_slug)
  return vim.tbl_filter(function(i)
    return i
  end, {
    plugin_slug:match("([a-zA-Z0-9]+).nvim"),
    plugin_slug:match("nvim.([a-zA-Z0-9]+)"),
    plugin_slug
  })
end

return M
