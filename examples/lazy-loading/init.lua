vim.g.baggage_path = vim.fn.stdpath("data") .. "/site/pack/baggage/"
if not vim.uv.fs_stat(vim.g.baggage_path) then
  vim.cmd("!git clone --filter=blob:none https://github.com/nocksock/baggage.nvim --branch=dev " .. vim.g.baggage_path .. 'start/baggage.nvim')
  vim.cmd("packloadall")
end

vim.g.mapleader = " "
