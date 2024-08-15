local r = R
local assert = require'luassert'
local stub = require'luassert.stub'

describe("handle", function ()
  local setup_spy
  local handle

  before_each(function()
    package.loaded['baggage.globals'] = { loaded = {} }
    setup_spy = stub()
    local plugin = r'baggage.create_plugin_from_url'("https://gitlab.com/nvim-telescope/telescope.nvim")
    handle = r'baggage.to_handle'(plugin)
    package.loaded['telescope'] = { setup = setup_spy }
  end)

  it("has a .setup function that calls the plugin's setup", function ()
    handle.setup('telescope', {})
    assert.stub(setup_spy).was_called()
  end)

  it("has a .setup function that calls the inferred plugin's setup", function ()
    handle.setup({})
    assert.stub(setup_spy).was_called()
  end)

  it("has a .lazily thunk to call setup lazily", function ()
    handle.lazily('telescope', {})
    assert.stub(setup_spy).was_not_called()
    handle.lazily('telescope', {})()
    assert.stub(setup_spy).was_called(1)
  end)

  it("has a .setup that can be called multiple times", function ()
    handle.setup({})
    handle.setup({})
    assert.stub(setup_spy).was_called(2)
  end)

  it("has a .once method that ensures that setup is only called once", function ()
    handle.once('telescope', {})
    handle.once('telescope', {})
    assert.stub(setup_spy).was_called(1)
  end)

  it("has a .lazily.once method that ensures that setup is only called once and is lazy", function ()
    handle.lazily.once('telescope', {})()
    handle.lazily.once('telescope', {})()
    assert.stub(setup_spy).was_called(1)
  end)

  it("has a wrap_setup method that returns creates a function that calls setup once before calling a passed callback", function ()
    local with_setup = handle.lazy_setup('telescope', {foo="bar"})
    local callback = stub()
    local trigger = with_setup(callback)
    assert.stub(callback).was_called(0)
    assert.stub(setup_spy).was_called(0)

    trigger({bar = "baz"})

    assert.stub(callback).was_called_with({bar ="baz"})
    assert.stub(setup_spy).was_called_with({foo = "bar"})

    trigger({bar = "baz"})
    assert.stub(callback).was_called(2)
    assert.stub(setup_spy).was_called(1)

    trigger({bar = "baz"})
    trigger({bar = "baz"})
    trigger({bar = "baz"})
    assert.stub(callback).was_called(5)
    assert.stub(setup_spy).was_called(1)
  end)


  it("can be called directly for setup", function ()
    handle('telescope', {})
    assert.stub(setup_spy).was_called()
  end)
end)
