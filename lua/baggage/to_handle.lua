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

      r'baggage.globals'.loaded[package_name] = true
    end
  end

  local lazily = function(name, opts)
    return function()
      setup(name, opts)
    end
  end

  local setup_once = function(name, opts)
    local p, package_name = r 'baggage.require_plugin' (name or plugin)

    if r'baggage.globals'.loaded[package_name] then
      return
    end

    if p and p.setup then
      p.setup(opts)
      assert(package_name)
      r'baggage.globals'.loaded[package_name] = true
    end
  end

  ---@class Handle
  local handle = {
    setup = setup,
    once = setup_once,
    load = function(name)
      return r 'baggage.require_plugin' (name or plugin)
    end,
    lazily = lazily,
    lazily_once = function(name, opts)
      return function() setup_once(name, opts) end
    end,
  }

  return setmetatable(handle, {
    __call = function(self, ...)
      return self.setup(...)
    end
  })
end
