local r = require

local called = {}

---creates a handle from a plugin
---@param plugin Plugin
return function(plugin)
  --TODO: type in such a way that the table has the right type
  ---@param name string
  ---@param opts? table
  ---@param force? boolean force call even when it was set up
  ---@overload fun(opts: table)
  local setup = function(name, opts, force)
    if type(name) == "string" and called[name] and not force then
      return;
    end

    local p = r'baggage.require'(name)

    if not p.setup then
      return
    end

    p.setup(opts)

    if type(name) == "string" then
      called[name] = true
    end
  end

  ---@class Handle
  local handle = {
    load = function(handle)
      r 'baggage.require' (handle or plugin)
    end,
    lazily = function(handle, opts)
      return function()
        setup(handle, opts)
      end
    end,
    setup = setup
  }

  return setmetatable(handle, {
    __call = function(self, ...)
      return self.load(...)
    end
  })
end
