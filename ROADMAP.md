# ROADMAP

## 0.0.0
- [x] create poc
- [x] decide on API
- [x] make it work for my own config
- [x] support for commits and tags

## 0.1.0
- [x] support for running commands after clone
- [x] support tables with options in from (+tests)
- [x] write initial setup routine
- [x] update images to have git configured properly (name email)
- [x] use submodule instead of clone
- [x] clone plugins into opt and call packadd in .from

## 0.2.0

- [x] display some ui during clone
- [x] create basic api for lazy-loading on events
- [x] add example using kickstart as a base
- [x] write tests for to_handle

## 0.3.0

- [ ] add commands

## 0.4.0

- [ ] add way for examples to use cached plugins to speed up debugging
- [ ] add support for local repos with fallback

## 0.5.0

- [ ] watcher for example runner
- [ ] automated tests using the examples

## 0.6.0

- [ ] generate and read lockfile?
- [ ] create basic api for lazy-loading on keypresses

## 0.7.0

- [ ] add keymap tracker to prevent duplicate keymaps
- [ ] provide example for lazy-loading
  - [ ] on events
  - [ ] on keypress

## 0.8.0

- [ ] add basic docs/help 

## 1.0.0

- [ ] scaffold bash command from examples

## brainfarts

- include version number in plugin-path if set
- documentation for plugin authors to use baggage in their plugin
- support for urls pointing to files and folders?

## Unsure

- [ ] support for a `dependency` property?

    I usually found that order of imports is much more intuitive. However including
    it would make the migration path from something like lazy a bit easier, since it
    would incloud less changes.

## Won't implemenent

and tasks that turned out not work

- A fancy UI

Instead of a UI, make it easy to run the appropriate git commands that will give
similar results and has far greater value

- [-] vim.g.baggage_* to vim.g.baggage.* for lsp?
  not worth it, because one would have to check if vim.g.baggage exists in 
  the install script

<!-- 
vi: ft=markdown
-->
