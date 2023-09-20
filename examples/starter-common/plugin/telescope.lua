local r = require

require'baggage'.from {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim/tree/0.1.x',
  { 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', on_sync = "make" },
}

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set('n', '<leader>?', r'telescope.builtin'.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', r'telescope.builtin'.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  r'telescope.builtin'.current_buffer_fuzzy_find(
    r'telescope.themes'.get_dropdown { winblend = 10, previewer = false }
  )
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', r'telescope.builtin'.git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', r'telescope.builtin'.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', r'telescope.builtin'.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', r'telescope.builtin'.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', r'telescope.builtin'.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', r'telescope.builtin'.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', r'telescope.builtin'.resume, { desc = '[S]earch [R]resume' })
