---@param plugin Plugin
---@return string[]
return function(plugin)
  return vim.tbl_filter(function(i)
    return i
  end, {
    plugin.name:match("([a-zA-Z0-9]+).nvim"),
    plugin.name:match("nvim.([a-zA-Z0-9]+)"),
    plugin.name
  })
end

