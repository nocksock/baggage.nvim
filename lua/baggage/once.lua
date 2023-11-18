local results = {}

local function maybe_call(fn, ...)
  if not results[fn] then
    results[fn] = { value = fn(...) }
  end

  return results[fn].value
end

local thunk = function(fn)
    return function()
      return maybe_call(fn)
    end
  end

local M = {
  lazy = thunk,
  defer = thunk,
  clear = function()
    results = {}
  end
}

return setmetatable(M, {
  __call = function(_, fn, ...)
    return maybe_call(fn, ...)
  end
})
