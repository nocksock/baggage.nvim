# ROADMAP

## 0.0.0 POC

- [x] create POC
- [x] decide on API
- [x] make it work for my own config
- [x] support for commits and tags


## 0.1.0 Making it usable
- [x] support for running commands after clone
- [x] support tables with options in from (+tests)
- [x] write initial setup routine
- [x] update images to have git configured properly (name email)
- [x] use sub module instead of clone
- [x] clone plugins into opt and call `packadd` in .from


## 0.2.0 Vertical slice

- [x] display some UI during clone
- [x] create basic API for lazy-loading on events
- [x] add example using Kickstart as a base
- [x] write tests for to_handle


## 0.3.0 Conveniences

- [x] add commands
    - [x] `:Baggage` to open a split of terminal and docs in a new tab with
    guidance on how to use git to update plugins

## 0.4.0 Examples

- [x] add way for examples to use cached plugins to speed up debugging
- [x] watcher for example runner


## 0.5.0 Letting it simmer

- [x] let it sit for a while

## 0.6.0 Brush up

- [ ] do a code review, refactor
- [ ] clone repos in parallel for each .from statement
- [ ] make core agnostic from nvim so it could be used in any lua env?

## 0.7.0 Utilities

- [x] create basic API for lazy-loading on key presses
- [x] provide example for lazy-loading
  - [x] on events
  - [x] on key press


## 0.8.0

- [ ] add docs/help 

## 1.0.0

- [ ] write proper readme


## Brainfarts

- include version number in plugin-path if set

## Unsure

- [ ] automated tests using the examples?


## Won't implement

And tasks that turned out not work or decided shouldn't be part of baggage.

- A fancy UI

Instead of a UI, make it easy to run the appropriate git commands that will give
similar results and has far greater value

- [-] vim.g.baggage_* to vim.g.baggage.* for LSP?
  Not worth it, because one would have to check if vim.g.baggage exists in 
  the install script

- [-] add keymap tracker to prevent duplicate keymaps

- [ ] support for a `dependency` property?
    I usually found that order of imports is much more intuitive. However including
    it would make the migration path from something like lazy a bit easier, since it
    would include less changes.
<!-- 
vi: ft=markdown
-->
