require 'baggage'
  .from {
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    {'https://github.com/nvim-telescope/telescope-fzf-native.nvim', { on_sync = "make" }}
  }
  .load 'telescope'

vim.cmd([[
  nmap <leader>f <cmd>Telescope find_files<cr>
  nmap <leader>F <cmd>Telescope find_files hidden=true cwd=%:p:h<cr>
]])
