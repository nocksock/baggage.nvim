local r = require

describe("baggage.plugin_from_remote_url", function ()
  it("works with local urls", function ()
    local result = r'baggage.plugin_from_local_url'("file://path/to/local/repo")
    assert.are.same(result.name, "path-to-local-repo")
    assert.are.same(result.clone_url, nil)
  end)
end)
