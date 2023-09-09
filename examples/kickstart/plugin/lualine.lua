-- Set lualine as statusline
require 'baggage'
  .from 'https://github.com/nvim-lualine/lualine.nvim'
  .setup {
    options = {
      icons_enabled = false,
      theme = 'onedark',
      component_separators = '|',
      section_separators = '',
    }
  }
