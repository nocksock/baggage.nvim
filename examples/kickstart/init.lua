--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

_G.r = require

-- Install package manager
--    https://github.com/nocksock/baggage.nvim
--    `:help baggage.nvim.txt` for more info
vim.g.baggage_path = vim.fn.stdpath("data") .. "/site/pack/baggage/"
if not vim.uv.fs_stat(vim.g.baggage_path) then
  vim.cmd("!git clone --filter=blob:none https://github.com/nocksock/baggage.nvim --verbose --branch=dev " ..
  vim.g.baggage_path .. 'start/baggage.nvim')
  vim.cmd("packloadall")
end

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require 'baggage'.from {
  -- NOTE: First, some plugins that don't require any configuration

  -- Detect tabstop and shiftwidth automatically
  'https://github.com/tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  'https://github.com/folke/which-key.nvim',

  -- Theme inspired by Atom
  'https://github.com/navarasu/onedark.nvim',

  -- Add indentation guides even on blank lines
  'https://github.com/lukas-reineke/indent-blankline.nvim',
}

require'which-key'.setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require 'indent_blankline'.setup({
  char = '┊',
  show_trailing_blankline_indent = false,
})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

vim.o.hlsearch = false -- Set highlight on search
vim.wo.number = true   -- Make line numbers default

vim.o.mouse = 'a'      -- Enable mouse mode

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
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

vim.cmd.colorscheme 'onedark'

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
