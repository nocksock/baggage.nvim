# the plugin folder

Files in this folder will be automatically loaded. That's default nvim behavior
and has nothing to do with baggage. You can put .vim and .lua files in here.

But you can also create folders that themselves again can have the same
structure as your configuration folder. read more about this at `:he rtp`

This lets you start with a small script and increase complexity of a part of
your configuration until it's a proper plugin. In truth it was a plugin from the
start already.
