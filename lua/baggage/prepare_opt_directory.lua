local r = require
---Ensures that the opt folder exists and is a clean git repo.
---@param _ Plugin
return function(_)
  local settings = r 'baggage.settings'
  if not vim.loop.fs_stat(settings.pack_path .. 'opt/')
    and not vim.loop.fs_stat(settings.pack_path .. 'opt/.git') then
    r 'baggage.within' (settings.pack_path .. 'opt/', function()
      vim.cmd("!git init -b main")
    end)
  end
end
