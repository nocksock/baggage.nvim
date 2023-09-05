---@param source string any url with a basic format similar to gitlab/sourcehut/github etc
---@return PluginSpec
return function(source)
  local host, org, name = source:match("https://([^/]+)/([^/]+)/([^/]+)/?")
  local commit = source:match("/tree/([^/]+)$")

  return {
    clone_url = "https://" .. host .. "/" .. org .. "/" .. name,
    name = name,
    org = org,
    commit = commit
  }
end
