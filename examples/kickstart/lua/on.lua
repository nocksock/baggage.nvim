local group = vim.api.nvim_create_augroup("UserAuGroup", { clear = true })

return function(events, callback)
  vim.api.nvim_create_autocmd(events, {
    group = group,
    callback = callback
  })
end
