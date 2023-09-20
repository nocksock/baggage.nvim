-- if you don't call any method on the return value of `from`, `setup` is a good
-- name, as it it includes a few methods that can be used to, well, setup
-- a plugin in specific way. eg. in a lazy way.
local setup = require'baggage'.from {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  -- if you want a much faster file-finder, uncomment the following:
  -- {'https://github.com/nvim-telescope/telescope-fzf-native.nvim', { on_sync = 'make' }}
}

-- for now, baggage does not ship with a helper function 
vim.api.nvim_create_autocmd({"BufEnter"}, {
  -- setup.lazily calls the plugin's setup method with the provided options
  -- - but lazily (so when its return value is called). Since events like
  -- BufEnter happen all the time, it also makes sure to only call it once.
  callback = setup.lazily('telescope', {
    -- telescope options
  })
})

-- This example includes a small helper function in `lua/on.lua`. Also note that
-- baggage.nvim creates a global alias for `r` for `require`, so the above can
-- also achieved with this:
-- r'on'({'BufEnter'}, setup.lazily('telescope', {
--   -- telescope options
-- }))

-- TODO: api for lazyloading on keypress
vim.keymap.set('n', '<leader>sf', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>sF', '<cmd>Telescope find_files hidden=true cwd=%:p:h<cr>')

r'baggage.map'({
  {'n', '<leader>sf', '<cmd>Telescope find_files<cr>'}
}, handle)

r'baggage.map'({
  {'n', '<leader>sf', '<cmd>Telescope find_files<cr>'}
}).setup(handle)

-- r'baggage.map' handle {
--   {'n', '<leader>sf', '<cmd>Telescope find_files<cr>'}
-- }

