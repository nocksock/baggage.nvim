local r = require
local called = {}

---creates a handle from a plugin
---@param plugin Plugin
return function(plugin)
  --TODO: type in such a way that the table has the right type
  ---@param name string
  ---@param opts? table
  ---@overload fun(opts: table)
  local setup = function(name, opts)
    if type(name) == 'table' then
      opts = name
      ---@diagnostic disable-next-line: cast-local-type
      name = nil
    end

    local p = r'baggage.require'(name or plugin)

    if not p.setup then
      return
    end

    p.setup(opts)
  end
  local lazily = function(handle, opts)
    return function()
      setup(handle, opts)
    end
  end
  ---@class Handle
  local handle = {
    load = function(handle)
      return r 'baggage.require' (handle or plugin)
    end,
    once = function(handle, opts)
      if called[handle] then
        return
      end

      setup(handle, opts)
      called[handle] = true
    end,
    lazily = lazily,
    setup = setup
  }

  return setmetatable(handle, {
    __call = function(self, ...)
      return self.setup(...)
    end
  })
end
