local M ={}

local event = require("baggage.events")

---comment
---@param plugin PluginSpec
event.on("ClonePost", function(plugin)
    if plugin.opts.on_sync and type(plugin.opts.on_sync) == "string" then
        M.run_sync(plugin, plugin.opts)
    else
        plugin.on_sync = plugin.opts.on_sync
    end
end)

---@param source string
---@param plugin_opts PluginOptions
function M.from_remote(source, plugin_opts)
    local fn = require("baggage.fn")
    local plugin = fn.extract_source_info(source)

    plugin.remote = true
    plugin.opts = plugin_opts or {}
    plugin.dirname = plugin.org .. "-" .. plugin.name
    plugin.path = vim.fn.stdpath("data") .. "/site/pack/baggage/start/" .. plugin.dirname

    if not vim.uv.fs_stat(plugin.path) then
        fn.info("cloning %s", plugin.clone_url)
        fn.system({ "git", "clone", plugin.clone_url, plugin.path }, function(result)
            if result.code ~= 0 then
                fn.error("Failed to clone plugin repository: %s", vim.inspect(result))
                return
            end

            if plugin.commit then
                fn.info("checking out commit %s", plugin.commit)
                fn.system({"git", "checkout", plugin.commit})
            end
        end)

        vim.cmd("helptags ALL")
        vim.cmd("packadd! " .. plugin.dirname)
    end

    return plugin
end

return M
