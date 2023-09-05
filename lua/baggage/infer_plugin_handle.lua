
---@param plugin_slug string
---@return string[]
return function(plugin_slug)
  return vim.tbl_filter(function(i)
    return i
  end, {
    plugin_slug:match("([a-zA-Z0-9]+).nvim"),
    plugin_slug:match("nvim.([a-zA-Z0-9]+)"),
    plugin_slug
  })
end

