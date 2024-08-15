local r = require
local assert = require 'luassert'
local stub = require 'luassert.stub'

local echo = function(...)
  return ...
end

describe("once", function()
  local once;
  local spy;
  local spy_other;

  before_each(function()
    package.loaded['baggage.globals'] = { loaded = {} }
    spy = stub()
    spy_other = stub()
    once = r 'baggage.once'
    once.clear()
  end)

  it("takes a function that is only called once", function()
    once(spy)
    once(spy_other)
    once(spy)
    once(spy_other)
    assert.stub(spy).was_called(1)
    assert.stub(spy_other).was_called(1)
  end)

  it("passes the args to the function", function()
    assert.are.same("foobar", once(echo, "foobar"))
  end)

  it("memoizes the result", function()
    local fn = stub().returns("foobar")
    once(fn)
    assert.are.same("foobar", once(fn))
  end)

  it("ignores args by default", function()
    once(echo, "foo")
    assert.are.same("foo", once(echo, "bar"))
  end)

  it("has .lazy to wrap the function in a thunk", function()
    local thunk = once.lazy(spy)
    thunk()
    thunk()
    assert.stub(spy).was_called(1)
  end)

  it("has .lazy that also memoizes the result", function()
    local thunk = once.lazy(spy.returns("foobar"))
    thunk()
    thunk()
    assert.are.same("foobar", thunk())
    assert.stub(spy).was_called(1)
  end)

  it("has .lazy to that also passes the args by default", function()
    local thunk = once.lazy(echo, "foo")
    thunk()
    assert.are.same("foo", thunk())
  end)

  it("has .wrap_lazy that creates a thunk builder that calls its initial callback before the thunk's callback", function()
    local setup_params = {foo = "bar"}
    local setup = stub()
    local with_setup = once.wrap_lazy(setup, setup_params)

    local on_callback = stub()
    local callback_params = {bar = "baz"}
    local trigger = with_setup(on_callback)

    assert.stub(setup).was_called(0)
    assert.stub(on_callback).was_called(0)

    trigger(callback_params)

    assert.stub(setup).was_called_with(setup_params)
    assert.stub(on_callback).was_called_with(callback_params)
  end)
end)
