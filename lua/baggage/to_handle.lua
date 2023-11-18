local r = require

---creates a handle from a plugin
---@param plugin Plugin
return function(plugin)
  --TODO: type in such a way that the table has the right type
  ---@param name? string
  ---@param opts? table
  ---@overload fun(opts: table)
  local setup = function(name, opts)
    if type(name) == 'table' then
      opts = name
      ---@diagnostic disable-next-line: cast-local-type
      name = nil
    end

    local p, package_name = r 'baggage.require_plugin' (name or plugin)

    if p and p.setup then
      p.setup(opts)

      assert(package_name, "no package name, despite successfull require.")

      r 'baggage.globals'.loaded[package_name] = true
    end
  end

  local once = r 'baggage.once'

  local load = function(name)
    return r 'baggage.require_plugin' (name or plugin)
  end

  ---@class Handle
  local handle = {
    setup = setup,
    once = once.defer(setup),
    load = load,
    lazily = setmetatable({
      once = function(name, opts)
        return once.defer(setup, name, opts)
      end
    }, {
      __call = function(_, ...)
        local args = { ... }
        return function ()
          return setup(unpack(args))
        end
      end
    }),
  }

  return setmetatable(handle, {
    __call = function(self, ...)
      return self.setup(...)
    end
  })
end
