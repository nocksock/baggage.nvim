---@param source string any url with a basic format similar to gitlab/sourcehut/github etc
---@param opts? PluginOptions
---@return Plugin
return function(source, opts)
  local settings = require'baggage.settings'
  ---@type string
  local name = source:match("file://(.*)")
  local plugin_opts = vim.tbl_extend('keep', opts or {}, {
    on_sync = nil,
    type = 'opt'
  })

  assert(type(name) == 'string', "expected a string, got " .. type(name))

  local dirname = name:gsub("/", "-")
  local path = settings.pack_path .. plugin_opts.type .. '/' .. dirname

  local clone_url = vim.uv.fs_stat(path .. ".git")
    and path .. ".git"
    or nil

  return {
    clone_url = clone_url,
    path = path,
    dirname = dirname,
    name = dirname,
    remote = false,
    opts = plugin_opts
  }
end
