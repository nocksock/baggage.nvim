# baggage.nvim

A thin wrapper around neovim's builtin package management and git with some helper methods.
Its goal is to create configuration files that are more easily to share and to embrace builtin features and external tools over abstractions.

Plugins are installed synchronously.
This *will* make the *initial* setup much slower than other package managers. 
However, this has no impact on subsequent startups and makes it possible to have a very simple API, without a complex configuration DSL:

```lua
require 'baggage'.from {
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
  'https://github.com/lewis6991/gitsigns.nvim',
}

-- gitsigns has been loaded at this point and can be required like normal
require 'gitsigns'.setup {}
```

Just like imports in most programming languages. 


## Installation

To install `baggage.nvim`, put this at the top of your `~/.config/nvim/init.lua`

(note: this part is very likely not going to change anymore)

```lua
vim.g.baggage_path = vim.fn.stdpath("data") .. "/site/pack/baggage/"
if not vim.loop.fs_stat(vim.g.baggage_path) then
  vim.cmd("!git clone https://github.com/nocksock/baggage.nvim " .. vim.g.baggage_path .. 'start/baggage.nvim')
  vim.cmd("packloadall")
end
```

## Usage


```lua
-- file: ~/.config/nvim/plugin/git.lua
require 'baggage' .from 'https://github.com/nocksock/do.nvim'

require 'do'.setup {
    -- [...]
}
```

`.from` returns a table with a handful of useful helper functions. 
Like: calling the plugin's setup method, calling setup lazily - and only once, which and allows for some neat patterns:

```lua
local setup = require 'baggage' .from 'https://github.com/stevearc/oil.nvim'

setup('oil', {
    default_file_explorer = true
    -- ... rest of oil config
})
```

`.from` can also take a table to include multiple urls as tables and call commands after installation as you might be familiar from other managers:

```lua
local setup = require 'baggage'.from {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim/tree/0.1.x',,
  { 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', on_sync = "make" },
}

setup('telescope', {
    --- telescope config
})

```

You might be curious about those URLs.

Baggage *deliberately* does not support short-urls for github.
Not only is that hurting the ecosystem to make github the defacto default plugin repository, it also makes it a bit more cumbersome to check a plugin's readme. 
This way it's just `gx` to open the browser with that url.
Sourcehut, GitLab, Codeberg and all other platforms that have this URL format are supported.

### Lazy Loading on Events

```lua
local bag = require 'baggage' .from 'https://github.com/foo/bar'

-- the handle can be called this way to setup a plugin:
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        bag 'do'.setup {}
    end
})

-- there's also a helper to make this even simpler
vim.api.nvim_create_autocmd("BufEnter", {
    callback = bag.lazily('foo', {})
})

-- and another to make sure setup is only called *once*
vim.api.nvim_create_autocmd("BufEnter", {
    callback = bag.lazily_once('foo', {})
})
```

These helper methods are incredibly thin, so thin that I encourage you to write your own.

### Lazy Loading on Keypress

`baggage` does not provide an abstraction around keymaps to handle this, instead you can build this with a couple of provided helper functions.

The `once` field in the handler provides a `wrap_lazy` function, that you can use like this:

```lua
local bag = require 'baggage' .from 'https://github.com/foo/bar'

local with_setup = bag.wrap_lazy(function()
    require("some-plugin").setup({ foo = "bar" })
    require('some-plugin').load_extension('baz') 
end)

vim.keymap.set({ "n" }, "<leader>t", with_setup(function()
  -- setup will have been called here, but won't be called multiple times
  require('some-plugin').call_some_fn()
end))
```

When the plugin name can be infered from the repository, this can also be written:

```lua
local bag = require 'baggage' .from 'https://github.com/foo/bar'

local with_setup = bag.with_setup("some-plugin", { 
    -- the configuration table
    foo = "bar"
})

vim.keymap.set({ "n" }, "<leader>t", with_setup(function()
  -- setup will have been called here, but won't be called multiple times
  require('some-plugin').call_some_fn()
end))
```

## Bag API

Assuming that `local bag = require 'baggage'.from "..."`

`bag(name, opts)` 
: identical to `require'name'.setup(opts)`

`bag.setup(name, opts)`
: identical to the above, useful for chaining

`bag.once(name,opts)`
: calls setup, but only if it hasn't been called before

`bag.lazily(name, opts)`
: returns a thunk that calls the setup

`bag.lazily_once(name, opts)` 
: returns a thunk that calls the setup, but *only* if it hasn't been called before
: otherwise it does nothing.


## Examples

The `examples` folder contains a growing list of example neovim setups for
specific use-cases and practical examples.

## Credits

Initial setup code was shamelessly copied from [AlphaKeks' dotfiles](https://github.com/AlphaKeks/.dotfiles/blob/master/LICENSE) with consent.
