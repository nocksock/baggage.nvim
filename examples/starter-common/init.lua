vim.g.baggage_path = vim.fn.stdpath("data") .. "/site/pack/baggage/"
if not vim.loop.fs_stat(vim.g.baggage_path) then
  vim.cmd("!git clone --filter=blob:none https://github.com/nocksock/baggage.nvim --verbose --branch=dev " ..
  vim.g.baggage_path .. 'start/baggage.nvim')
  vim.cmd("packloadall")
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'baggage'.from {
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/folke/tokyonight.nvim'
}

require'which-key'.setup()

require 'indent_blankline'.setup({
  char = '┊',
  show_trailing_blankline_indent = false,
})

vim.o.hlsearch = false -- Set highlight on search
vim.wo.number = true   -- Make line numbers default
vim.o.mouse = 'a'      -- Enable mouse mode

vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true    -- Save undo history
vim.o.ignorecase = true  -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true

vim.wo.signcolumn = 'yes' -- Keep signcolumn on by default

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.o.termguicolors = true             -- NOTE: You should make sure your terminal supports this

vim.cmd.colorscheme 'tokyonight'

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et
