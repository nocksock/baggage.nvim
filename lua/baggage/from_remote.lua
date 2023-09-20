local r = require
---@param source string
---@param opts PluginOptions
return function(source, opts)
  local plugin   = r'baggage.create_plugin_from_url' (source, opts)

  r'baggage.prepare_opt_directory'(plugin)
  if not vim.uv.fs_stat(plugin.path) then
    r'baggage.within'(r'baggage.settings'.opt_path, function()
      -- using vim.cmd because vim.fn.system also blocks the UI when running synchroneously so we
      -- can't print info messages. But we *have* to run synchrounously because code after the call to
      -- from relies on packages existing.
      if plugin.commit then
        vim.cmd("!git submodule add --branch ".. plugin.commit .. " " .. plugin.clone_url .. " " .. plugin.dirname)
      else
        vim.cmd("!git submodule add " .. plugin.clone_url .. " " .. plugin.dirname)
      end

      vim.cmd("!git commit -m 'add: " .. plugin.dirname .. "'")
    end)

    r'baggage.within'(plugin.path, function()
      if plugin.opts.on_sync then
        if vim.startswith(plugin.opts.on_sync, ":") then
          vim.cmd(plugin.opts.on_sync:sub(2))
        else
          vim.cmd("! " .. plugin.opts.on_sync)
        end
      end

      if vim.uv.fs_stat(plugin.path .. "/doc") then
        vim.cmd("helptags " .. plugin.path .. "/doc")
      end
    end)
  end

  vim.cmd("packadd " .. plugin.dirname)

  -- this is a workaround to get rid of the "hit enter" prompt
  -- TODO: research/try if there is a better way (:he hit-enter)
  local keys = vim.api.nvim_replace_termcodes("<cr>", true, true, true)
  vim.api.nvim_feedkeys(keys, 'n', false)

  return plugin
end
