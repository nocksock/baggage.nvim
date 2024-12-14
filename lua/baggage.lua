local M = {}

_G.LOADED_PLUGINS = {}

---Ensure that a plugin has been cloned into neovim's package folder.
---Note that this does neither call setup nor does it even require the module.
---
--- Example:
---   require'baggage'.from'neovim/nvim-lspconfig'
---
---@param origin string|(string|table)[]
---@param opts? PluginOptions
---@return Handle
M.from = function(origin, opts)
  if type(origin) == 'table' then
    local plugins = vim.tbl_map(function(o)
      if type(o) == 'table' then
        return M.from(o[1], o[2])
      end
      return M.from(o)
    end, origin)
    -- return a handle with the last plugin of the list closed in.
    return plugins[#plugins]
  end

  local plugin = require 'baggage.from_remote' (origin, opts)
  return require 'baggage.to_handle' (plugin)
end

return {
  from = M.from
}
