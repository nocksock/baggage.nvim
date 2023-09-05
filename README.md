# baggage.nvim

Yet another plugin/package manager.

move along. nothing to see here, yet.

## goals

- create portable/copy-pasteable single-purpose plugin files
- thin wrapper around git
- implicit lockfile via git submodules
- prefer existing tools instead of abstractions around them
- designed to be easily opted-out in favor builtin tools of neovim
- support for packages not just plugins
- provide helpful and guiding error messages

## Install

don't... yet.

## Usage

```lua
require 'baggage'
    .from 'https://github.com/foo/bar'
    .load() 
```
load will call `require` of pluign.
It tries to infer the name from the usual conventions.
If it can't, it will throw an error message 

### Lazyloading

`baggage.nvim` has no builtin abstraction for lazyloading, as I think that 
the builtin possibilies are good enough and plugin authors should get their
shits together and be mindful of loading performance instead.

```lua
-- variant a:
require 'baggage'
    .from 'https://github.com/foo/bar'

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local bar = require('bar')
  end
})

-- variant b:
local bar_baggage = require 'baggage'
    .from 'https://github.com/foo/bar'

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local bar = bar_baggage.load()
  end
})
```

Is this too much boilerplate for you? 
Write a tiny helper function!

```lua
-- lua/utils/on.lua
return function on(event, callback)
    vim.api.nvim_create_autocmd(events, {
        callback = callback
    })
end

-- plugin/telescope.lua
local load_telescope = require 'baggage' 
    .from 'https://github.com/nvim-telescope/telescope.nvim'
    .load -- note the missing ()
local on = require('utils.on')

on({"BufEnter"}, load_telescope)
```

or:

```lua
require 'utils.on' ({"BufEnter"}, require('baggage')
    .from 'https://github.com/nvim-telescope/telescope.nvim'
    .load
)
```

### load multiple

There are a few styles to get multiple plugins in a a single expression.
Choose whatever fits your config best.

```lua
-- chained:
require 'baggage'
  .from 'https://github.com/nvim-telescope/telescope.nvim'
  .from 'https://github.com/nvim-telescope/telescope-ui-select.nvim'
  .from('https://github.com/nvim-telescope/telescope-fzf-native.nvim', { on_sync = "make" })

-- as a table
require 'baggage' {
    'https://github.com/nvim-telescope/telescope.nvim' ,
    'https://github.com/nvim-telescope/telescope-ui-select.nvim' 
    { 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', { on_sync = "make" }},
}
```

### helper fns

```lua
local fn = require "baggage.fn".
fn.on({"BufEnter"}, function()
    require('something')
end)
```

### commands

- `BaggageList` Lists all loaded plugins
- `BaggageList!` List all plugins that have not been loaded
- `BaggageClean` Remove plugins that have not been loaded


## Credits

some parts have been shamelessly copied from [AlphaKeks' dotfiles](https://github.com/AlphaKeks/.dotfiles/blob/master/LICENSE)
