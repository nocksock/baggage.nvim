# baggage.nvim

A thin wrapper around neovim's builtin package management and git with some helper methods.
Its goal is to create configuration files that are more easily to share and to embrace builtin features and external tools over abstractions.

Instead of trying to optimise initial *cloning* speed, it install plugins synchronously. 
This makes handling dependencies much simpler, and makes writing portable configurations much easier.

## Features

- Install plugins via git
- Minimal abstraction
- Manage plugins *yourself* and become independent of plugin managers.
- Provides step-by-step instruction instead of a quick command to update, so you don't update your plugins habitually and potentially break things.

## Installation

To install, put this at the top of your `~/.config/nvim/init.lua`

(note: this part is very likely not going to change anymore)
```lua
vim.g.baggage_path = vim.fn.stdpath("data") .. "/site/pack/baggage/"
if not vim.loop.fs_stat(vim.g.baggage_path) then
  vim.cmd("!git clone https://github.com/nocksock/baggage.nvim " .. vim.g.baggage_path .. 'start/baggage.nvim')
  vim.cmd("packloadall")
end
```

## Usage

`baggage` installs missing plugins synchronously and sequentially. 
This takes *much* longer the first time than approaches by other managers.
However it removes the need to define a list of plugins ahead of setup and makes it possible to colocate them alongside their configuration, eg. within the `plugin/` folder.

This gives a similar style to how you would use/import packages in other 
programming languages:

```lua
-- file: ~/.config/nvim/plugin/git.lua
require 'baggage' .from 'https://github.com/nocksock/do.nvim'

require 'do'.setup {
    -- [...]
}
```

As it's synchronously installing when needed execution of the rest of the file is blocked until installation is finished. 

`.from` returns a `setup-handle`.
It provides a handful of common helper functions, like calling the plugin's setup method and allows for some useful patterns using neovim's api:

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
Most managers only need something like `nvim-lua/plenary` instead of the full URL.
However I think it's not only hurting the ecosystem to declare github as the defacto default plugin repository, it also makes it a bit more cumbersome to check a plugin's readme, while also making it clear that it's an external dependency instead of a local folder.
Just `gx` and it will open the browser with that url.

And yes, gitlab, sourcehut and all other platforms that have this URL format are supported - at the end it's *basically* just a `git clone <url>`, with some tweaks when pointing to branches/commits/tags.

### Lazy Loading on Events

But what if a plugin is slow on startup?
Notice that you still have to `require` the plugin manually each time.
If you want to lazily load your plugin on certain events, you can lean on neovim's API instead of an builtin abstraction around it:

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

These helper methods are incredibly thin and I invite you to look at them and use your own implementation.
It's a good exercise to understandg more fundamentals of lua and neovim.

### Lazy Loading on Keypress

Similar to the above you'll often want to run some code once, but have multiple ways of triggering it.
The most common use-case would be keymaps, where you'll want to require and setup a plugin only once, but you have mutliple keys that could trigger it.

`baggage` does not provide an abstraction around keymaps to handle this, instead it provides functions to make handling these common scenarios easier, in order for you to understand nvim and its carefully crafted API better.
This "inversion of control" has the benefit of providing solutions for scenarios I haven't even anticipated.

For this, the `once` module provides a `wrap_lazy` function, that you can use like this:

```lua
local bag = require 'baggage' .from 'https://github.com/foo/bar'

local with_setup = bag.wrap_lazy(function()
    r("some-plugin").setup({ foo = "bar" })

    -- of course any other code related to setting a plugin, or a set of plugins up,
    -- should be put here as well:
    r('some-plugin').load_extension('baz') 
end)

vim.keymap.set({ "n" }, "<leader>t", with_setup(function()
  -- setup will have been called here, but won't be called multiple times
  r('some-plugin').call_some_fn()
end))
```

And for plugins that adhere to the standard of exposing a "setup" function - which really are most nvim plugins - there's `with_setup` on `bag` to save some boilerplate.

```lua
local bag = require 'baggage' .from 'https://github.com/foo/bar'

local with_setup = bag.with_setup("some-plugin", { foo = "bar" })

vim.keymap.set({ "n" }, "<leader>t", with_setup(function()
  -- setup will have been called here, but won't be called multiple times
  r('some-plugin').call_some_fn()
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


(warning not sure if I will keep the following)
*NOTE*: `name` can be omitted in a lot of cases. 
It tries to infer the plugin name of the *last* plugin in a `.from`-table by one of the common patterns: `foo`, `nvim-foo`, `foo.nvim`

## Examples

The `examples` folder contains a growing list of example neovim setups for
specific use-cases and practical examples.

## Motivation

- easy to share `plugin/*.lua` files for easy copy paste - especially for newcomers

## Credits

Initial setup code was shamelessly copied from [AlphaKeks' dotfiles](https://github.com/AlphaKeks/.dotfiles/blob/master/LICENSE) with consent.
