# Examples

Examples serve two purposes:

3. As starting points for newcomers to neovim with specific but common use-cases
2. As integration tests

## Usage

### Running Containers

To run an example, there's the `./run` script.

```
$ ./run <name-of-example>

# example:

./run minimal

```

Note: can also be run from the root of this project. Always make sure to refer
to the command as either `examples/run` or `./run` in any kind of documentation
you might include in your own examples.

## Guidelines

As this is fairly fresh, I'm certain a lot of this will change over time. So none
of this is set in stone and everything can be broken when it benefits the goal
of helping and guiding newcomers.

Each example should be a good starting point of a fresh config with helpful
pointers to `:help` yet not to the point of writing a neovim-tutorial.

### Keymaps

Include as little keymaps as possible. When you do, prefer vim-idioms
rather than personal preference. And keep them closely tied to the point of the
examples. 

### Plugins

Group plugins in the `plugin` folder in a way that makes sense. Refer to
existing examples to get a feel for it. 

Examples:
```
examples/minimal/
├── init.lua
└── plugin
    ├── git.lua
    ├── autocompletion.lua
    ├── lsp.lua
    └── telescope.lua
```

But this might also make sense:

```
examples/lsp-ish
├── init.lua
└── plugin
    ├── git.lua
    ├── autocompletion.lua
    ├── react.lua
    └── rust.lua
```

Think about the potential consumer of the example - usually a newcomer to neovim
who want's to set it up for some language to work in.

Also include as few plugins as possible to make an example work for the specific
use-case. For example don't include things like `noice.nvim` when the use case
is to create an environment for working with react.

Consider making two examples to set it up?

### Helper functions

Avoid helper functions - especially for `plugin/*`-files as they will make it 
harder to copy paste configurations and the goal is to have these as 
copy-pasteable as possible. If you think a helper function would make something 
much easier for newcomers, make sure the helper function itself is readable and
well commented.
