local M = {}
local group = vim.api.nvim_create_augroup("Baggage", { clear = true })

M.on = function(event, callback)
  vim.api.nvim_create_autocmd("User", { 
      callback = callback,
      group    = group,
      pattern  = event,
  })
end

M.trigger = function(event, data)
    vim.api.nvim_exec_autocmds("User", {
        data    = data,
        group   = group,
        pattern = event,
    })
end


return M
