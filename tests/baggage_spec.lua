local assert = require'luassert'
local stub = require'luassert.stub'

describe('from', function ()
  it('takes a single url', function ()
    local spy = stub()
    package.loaded['baggage.from_remote'] = spy
    require'baggage'.from 'https://github.com/nvim-telescope/telescope.nvim'
    assert.stub(spy).was_called_with('https://github.com/nvim-telescope/telescope.nvim', nil)
  end)

  it('takes multiple urls', function ()
    local spy = stub()
    package.loaded['baggage.from_remote'] = spy
    require'baggage'.from {
      'https://github.com/nvim-telescope/telescope.nvim',
      'https://github.com/nvim-telescope/telescope-fzf-native.nvim'
    }
    assert.stub(spy).was_called_with('https://github.com/nvim-telescope/telescope.nvim', nil)
    assert.stub(spy).was_called_with('https://github.com/nvim-telescope/telescope-fzf-native.nvim', nil)
  end)

  it('takes multiple urls and option', function ()
    local spy = stub()
    package.loaded['baggage.from_remote'] = spy
    require'baggage'.from {
      'https://github.com/nvim-telescope/telescope.nvim',
      { 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', {on_sync = "make"}}
    }
    assert.stub(spy).was_called_with('https://github.com/nvim-telescope/telescope.nvim', nil)
    assert.stub(spy).was_called_with('https://github.com/nvim-telescope/telescope-fzf-native.nvim', {on_sync = "make"})
  end)
end)
