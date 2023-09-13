local assert = require'luassert'
local stub = require'luassert.stub'

describe("handle", function ()
  local spy
  local handle

  before_each(function()
    local plugin = r'baggage.create_plugin_from_url'("https://gitlab.com/nvim-telescope/telescope.nvim")
    handle = r'baggage.to_handle'(plugin)
    spy = stub()
    package.loaded['telescope'] = { setup = spy }
  end)

  it("has a .setup that calls the plugin's setup", function ()
    handle.setup('telescope', {})
    assert.stub(spy).was_called()
  end)

  it("has a .setup that calls the inferred plugin's setup", function ()
    handle.setup({})
    assert.stub(spy).was_called()
  end)

  it("has a .lazily thunk for setup", function ()
    handle.lazily('telescope', {})()
    assert.stub(spy).was_called()
  end)

  it("has a .lazily thunk for setup", function ()
    handle.lazily('telescope', {})()
    assert.stub(spy).was_called()
  end)

  it("has a .setup that can be called multiple times", function ()
    handle.setup({})
    handle.setup({})
    assert.stub(spy).was_called(2)
  end)

  it("has a .once method that ensures that setup is only called once", function () 
    handle.once('telescope', {})
    handle.once('telescope', {})
    assert.stub(spy).was_called(1)
  end)

  it("can be called directly for setup", function ()
    handle('telescope', {})
    assert.stub(spy).was_called()
  end)
end)
