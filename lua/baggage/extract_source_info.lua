local r = require
---@param source string any url with a basic format similar to gitlab/sourcehut/github etc
---@return Plugin
return function(source)
  local host, org, name = source:match("https://([^/]+)/([^/]+)/([^/]+)/?")
  local commit = source:match("/tree/([^/]+)$")

  return {
    clone_url = "https://" .. host .. "/" .. org .. "/" .. name,
    name = name,
    org = org,
    commit = commit,
    remote = true,
  }
end
