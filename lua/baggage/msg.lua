local r = require
local M = {}

M.trace = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.TRACE)
end

M.debug = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.DEBUG)
end

M.info = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.INFO)
end

M.warn = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.WARN)
end

M.error = function(msg, ...)
  return vim.notify(msg:format(...), vim.log.levels.ERROR)
end

return M
