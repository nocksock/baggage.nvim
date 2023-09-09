return function(events, callback)
    vim.api.nvim_create_autocmd(events, {
        callback = callback
    })
end
