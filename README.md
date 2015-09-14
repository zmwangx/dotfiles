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
