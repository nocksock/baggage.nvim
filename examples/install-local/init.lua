vim.g.baggage_path = vim.fn.stdpath("data") .. "/site/pack/baggage/"
if not vim.uv.fs_stat(vim.g.baggage_path) then
  vim.cmd("!git clone file:///root/baggage.git --branch=dev " .. vim.g.baggage_path .. 'start/baggage.nvim')
  vim.cmd("packloadall")
end

require "baggage".from {
    "https://github.com/nvim-lua/plenary.nvim",
    'https://github.com/nvim-telescope/telescope.nvim',
  }
  .load 'telescope'

vim.cmd([[
  nmap <leader>f <cmd>Telescope find_files<cr>
  nmap <leader>F <cmd>Telescope find_files hidden=true cwd=%:p:h<cr>
]])
