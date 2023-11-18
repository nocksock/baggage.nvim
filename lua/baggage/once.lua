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

return setmetatable({
  lazy = thunk,
  defer = thunk,
  clear = function()
    results = {}
  end
}, {
  __call = function(_, fn, ...)
    return maybe_call(fn, ...)
  end
})
