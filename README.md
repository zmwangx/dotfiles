This repository contains most of my vital config files.

## Getting started

```zsh
git clone --recursive git@github.com:zmwangx/dotfiles.git ~/.config
# create data/cache directories and link some dotfiles or dot directories to HOME
~/.config/setup
```

To provision a new OS X install, do `~/.config/provision` instead (requires
Xcode and CLT).

Also, `source ~/.config/env` should go into `.bashrc`, `.zshenv` (done for you
when you run `~/.config/setup`, which sets up `.bashrc` and `.zshenv` in your
home directory), and its equivalent should go into the runcoms of other
noninteractive (POSIX-compatible) shells.

Note that config files with credentials have been excluded from the directory,
and their `.template` counterparts have been committed in instead. Replace the
redacted credentials (generally in the form `XXXXXX`) with the actual values.

## XDG offenders

You are invited to visit the Homedir Hall of Shame
([`HALLOFSHAME.md`](HALLOFSHAME.md)).

## License

**The MIT License (MIT)**

Copyright (c) 2015 Zhiming Wang

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
