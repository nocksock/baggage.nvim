describe('create_plugin_candidates', function()
  it('generates the usual canidates', function()
    assert.are.same(require'baggage.infer_plugin_handle'({name="nvim-foo"}), {
      'foo',
      'nvim-foo'
    })

    assert.are.same(require'baggage.infer_plugin_handle'({name="telescope.nvim"}), {
      'telescope',
      'telescope.nvim'
    })
  end)
end)
