describe('create_plugin_candidates', function()
  it('generates the usual canidates', function()
    assert(vim.deep_equal(require'baggage.infer_plugin_handle'("nvim-foo"), {
      'foo',
      'nvim-foo'
    }))

    assert(vim.deep_equal(require'baggage.infer_plugin_handle'("telescope.nvim"), {
      'telescope',
      'telescope.nvim'
    }))
  end)
end)
