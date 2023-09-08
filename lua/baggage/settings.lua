---@class BaggageSettings
local M = {
  pack_path = vim.g.baggage_path or error("vim.g.baggage_path is not set!"),
  opt_path = vim.g.baggage_path .. 'opt/',
}

return M
