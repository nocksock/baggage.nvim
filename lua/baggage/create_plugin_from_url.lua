local r = require

---@class Plugin
---@field name string
---@field path string
---@field dirname string
---@field org string
---@field clone_url string
---@field commit string
---@field type 'opt' | 'start'
---@field opts PluginOptions

---@class PluginOptions
---@field on_sync string

---@param source string any url with a basic format similar to gitlab/sourcehut/github etc
---@param opts? PluginOptions
return function(source, opts)
  if vim.startswith(source, 'https://') then
    return require'baggage.plugin_from_remote_url'(source, opts)
  end

  if vim.startswith(source, 'file://') then
    return require'baggage.plugin_from_local_url'(source, opts)
  end

  error("unsupported source, only https and file allowed, received: " .. source .. "")
end
