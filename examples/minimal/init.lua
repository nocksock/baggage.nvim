vim.g.baggage_path = vim.fn.stdpath("data") .. "/site/pack/baggage/"-- {{{
if not vim.uv.fs_stat(vim.g.baggage_path) then
  vim.cmd("!git clone --filter=blob:none https://github.com/nocksock/baggage.nvim --verbose --branch=dev " ..
  vim.g.baggage_path .. 'start/baggage.nvim')
  vim.cmd("packloadall")
end-- }}}

vim.g.mapleader = " "

local setup = require "baggage".from {
  "https://github.com/nvim-lua/plenary.nvim",
  'https://github.com/tpope/vim-vinegar',
  'https://github.com/nvim-telescope/telescope.nvim/tree/0.1.x',
  { 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', on_sync = "make" },
}

vim.cmd.colorscheme {"habamax"}

r 'baggage.on' ({ "BufEnter" }, setup.lazily('telescope'))

vim.keymap.set("n", "<leader>f", "<cmd>Telescop find_files<cr>");

vim.o.rnu = true
vim.o.nu = true
