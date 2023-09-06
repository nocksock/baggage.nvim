local r = require
local assert = require 'luassert'
local stub = require 'luassert.stub'
local mock = require 'luassert.mock'
local match = require 'luassert.match'

describe("from_remote", function()
  it("calls system to clone", function()
    local remote = 'https://github.com/nvim-telescope/telescope.nvim'
    local plugin = r 'baggage.extract_source_info' (remote)
    local settings = r 'baggage.settings'

    package.loaded['baggage.system'] = stub()
    local uv = mock(vim.uv, true)
    uv.fs_stat.returns(false)

    r'baggage.from_remote'(remote, {})
    assert.stub(r'baggage.system')
        .was_called_with(
          { "git", "clone", plugin.clone_url, settings.pack_path .. "nvim-telescope-telescope.nvim" },
          match._
        )
  end)

  it("does not call on_sync without clone", function()
    local remote = 'https://github.com/nvim-telescope/telescope.nvim'
    local plugin = r 'baggage.extract_source_info' (remote)
    local settings = r 'baggage.settings'

    package.loaded['baggage.run_sync'] = stub()
    local uv = mock(vim.uv, true)
    uv.fs_stat.returns(true)

    local p = r'baggage.from_remote'(remote, { on_sync = "make"})

    assert.are.same(p.opts, {on_sync="make"})
    assert.stub(r'baggage.run_sync')
        .was_not.called_with(p)
  end)

  it("calls on_sync after clone", function()
    local remote = 'https://github.com/nvim-telescope/telescope.nvim'
    local plugin = r 'baggage.extract_source_info' (remote)
    local settings = r 'baggage.settings'

    package.loaded['baggage.run_sync'] = stub()
    local uv = mock(vim.uv, true)
    uv.fs_stat.returns(false)

    local p = r'baggage.from_remote'(remote, { on_sync = "make"})

    assert.are.same(p.opts, {on_sync="make"})
    assert.stub(r'baggage.run_sync')
        .was_called_with(p)
  end)
end)
