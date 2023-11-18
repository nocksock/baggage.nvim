# ROADMAP

## 0.0.0 poc

- [x] create poc
- [x] decide on API
- [x] make it work for my own config
- [x] support for commits and tags


## 0.1.0 making it usable
- [x] support for running commands after clone
- [x] support tables with options in from (+tests)
- [x] write initial setup routine
- [x] update images to have git configured properly (name email)
- [x] use submodule instead of clone
- [x] clone plugins into opt and call packadd in .from


## 0.2.0 vertical slice

- [x] display some ui during clone
- [x] create basic api for lazy-loading on events
- [x] add example using kickstart as a base
- [x] write tests for to_handle


## 0.3.0 conveniences

- [ ] add commands
    - [ ] `:Baggage` to open a split of terminal and docs in a new tab with
    guidance on how to use git to update plugins

## 0.4.0 examples

- [x] add way for examples to use cached plugins to speed up debugging
- [x] watcher for example runner


## 0.5.0 let it simmer

- [x] let it sit for a few days

## 0.6.0 brush up

- [ ] do a code review, refactor


## 0.7.0 utilities

- [ ] create basic api for lazy-loading on keypresses
- [ ] add keymap tracker to prevent duplicate keymaps
- [x] provide example for lazy-loading
  - [x] on events
  - [ ] on keypress


## 0.8.0

- [ ] add docs/help 

## 1.0.0

- [ ] write proper readme


## brainfarts

- include version number in plugin-path if set


## Unsure

- [ ] automated tests using the examples?
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
