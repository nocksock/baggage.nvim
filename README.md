> ⚠ Warning: this is in early access. Things will break, things will change, and
> there'll be breaking changes. Also it's not complete yet. The following is
> an incomplete draft that likely isn't up to date with the plugin's API.

# baggage.nvim

A slightly different take on plugin management in neovim. 

It's a thin wrapper around neovim's builtin package management and git with 
some helper methods. The goal is to create configuration files that are more 
easily to share and to embrace builtin features and external tools over 
abstractions in favor of simplicity at the cost of installation time during 
startup (if any).


## Features

tbd

## Installation

To install, put this at the top of your `~/.config/nvim/init.lua`

(note: this part is very likely not going to change anymore)
```lua
vim.g.baggage_path = vim.fn.stdpath("data") .. "/site/pack/baggage/"
if not vim.uv.fs_stat(vim.g.baggage_path) then
  vim.cmd("!git clone https://github.com/nocksock/baggage.nvim " .. vim.g.baggage_path .. 'start/baggage.nvim')
  vim.cmd("packloadall")
end
```

## Usage

`baggage` installs missing plugins synchronously and sequentially. While this
takes *much* longer the first time, it removes the need to define a list of
plugins as early as possible and makes it possible to colocate them alongside
their configuration, eg. within the `plugin/` folder.

This gives a similar style to how you would use/import packages in other 
programming languages:

```lua
-- file: ~/.config/nvim/plugin/git.lua
require 'baggage' .from 'https://github.com/tpope/vim-fugitive'

-- [...]
```

As it's synchronously installing when needed execution of the rest of the file
is blocked until installation is finished. 

`.from` exposes a `setup-handle` - which is just a table with a handful of 
common helper functions to call the plugin's setup method and allows for some 
useful patterns using neovim's api:

```lua
local setup = require 'baggage' .from 'https://github.com/stevearc/oil.nvim'

setup('oil', {
    default_file_explorer = true
    -- ... rest of oil config
})
```

`.from` can also take a table to include multiple urls as tables and call
commands after installation as you might be familiar from other managers:

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

You might be curious about those URLs. Most managers only need something like
`nvim-lua/plenary` instead of the full URL. However I think it's not only hurting the
ecosystem to declare github as the defacto default plugin repository, it also
makes it a bit more cumbersome to check a plugin's readme, while also making it
clear that it's an external dependency instead of a local folder. Just `gx` and
it will open the browser with that url.

And yes, gitlab, sourcehut and all other platforms that have this URL format are
supported - at the end it's *basically* just a `git clone <url>`, with some tweaks
when pointing to branches/commits/tags.


### Lazy Loading on Events

```lua
local setup = require 'baggage' .from 'https://github.com/foo/bar'

-- the handle can be called this way to setup a plugin:
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        setup('foo', {})
    end
})

-- there's also a helper to make this even simpler
vim.api.nvim_create_autocmd("BufEnter", {
    callback = setup.lazily('foo', {})
})

-- and another to make sure setup is only called *once*
vim.api.nvim_create_autocmd("BufEnter", {
    callback = setup.lazily_once('foo', {})
})
```

### Lazy Loading on Keypress

tbd

## Handle API

- `setup(name, opts)` is identical `require'name'.setup(opts)`
- `setup.setup(name, opts)` identical to the above, for chaining
- `setup.once(name,opts)` calls setup, but only if it hasn't been called before
- `setup.lazily(name, opts)` returns a thunk that calls the setup
- `setup.lazily_once(name, opts)` returns a thunk that calls the setup, but
only if it hasn't been called before

note that `name` can be omitted in a lot cases. It tries to infer the plugin name
of the *last* plugin in a `.from`-table by one of the common patterns: `foo`, `nvim-foo`, `foo.nvim`

## Examples

The `examples` folder contains a growing list of example neovim setups for
specific use-cases and practical examples.

## Motivation

todo
- easy to share `plugin/*.lua` files for easy copy paste - especially for newcomers

## Credits

Initial setup code was shamelessly copied from [AlphaKeks' dotfiles](https://github.com/AlphaKeks/.dotfiles/blob/master/LICENSE).
