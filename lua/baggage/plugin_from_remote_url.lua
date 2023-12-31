---@param source string any url with a basic format similar to gitlab/sourcehut/github etc
---@param opts? PluginOptions
---@return Plugin
return function(source, opts)
  local settings = require'baggage.settings'
  local host, org, name = source:match("https://([^/]+)/([^/]+)/([^/]+)/?")
  local commit = source:match("/tree/([^/]+)$")
  local plugin_opts = vim.tbl_extend('keep', opts or {}, {
    on_sync = nil,
    type = 'opt'
  })

  local dirname = org .. "-" .. name
  local path = settings.pack_path .. plugin_opts.type .. '/' .. dirname

  return {
    clone_url = "https://" .. host .. "/" .. org .. "/" .. name,
    path = path,
    dirname = dirname,
    name = name,
    org = org,
    commit = commit,
    remote = true,
    opts = plugin_opts
  }
end
