local results = {}

local function maybe_call(fn, ...)
  if not results[fn] then
    results[fn] = { value = fn(...) }
  end

  return results[fn].value
end

local thunk = function(fn, ...)
  local args = {...}
  return function()
    return maybe_call(fn, unpack(args))
  end
end

local wrap_lazy = function(setup_fn, ...)
  local setup = thunk(setup_fn, ...)
  return function(cb)
    return function(...)
      local args = {...}
      setup()
      return cb(unpack(args))
    end
  end
end


return setmetatable({
  lazy = thunk,
  wrap_lazy = wrap_lazy,
  defer = thunk,
  clear = function()
    results = {}
  end
}, {
  __call = function(_, fn, ...)
    return maybe_call(fn, ...)
  end
})
