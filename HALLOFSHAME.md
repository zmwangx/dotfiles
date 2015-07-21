# Homedir Hall of Shame

Here are a list of projects that insist on living in the home directory and
whose dotfiles or dotdirs are either hard or impossible to move or factor.

## TL;DR / Table of Shames

Shame on them:

* [colordiff](#colordiff)
* [CUPS](#cups)
* [Dropbox](#dropbox)
* [gist](#gist)
* [Heroku toolbelt](#heroku-toolbelt)
* [Keybase installer](#keybase-installer)
* [matplotlib](#matplotlib)
* [mutt](#mutt)
* [GNU Parallel](#gnu-parallel)
* [PyPI](#pypi)
* [Shout](#shout)
* [tox](#tox)
* [Travis client](#travis-client)
* [tmux](#tmux)

## Reasonable

There are large and crucial projects that somewhat deserve a space in
`HOME`. The "reasonable" list also includes projects that install binaries to
`HOME`, e.g., Linuxbrew, and various version managers.

* Shells:

  * Bash;
  * Zsh (including `.zprezto`).

* Editors:

  * Atom;
  * Emacs.

* Version managers:

  * pyenv;
  * RVM.

* Misc:

  * fontconfig;
  * GnuPG;
  * Linuxbrew;
  * SSH.

## Shameful

These projects should feel ashamed by their lack of customizability and
pollution to user home.

### colordiff

`"$ENV{HOME}/.colordiffrc"` is hard-coded in
[source code](https://github.com/daveewart/colordiff/blob/current/colordiff.pl).

PR: [`daveewart/colordiff#24`](https://github.com/daveewart/colordiff/pull/24).

### CUPS

See the `FILES` section of `man 1 cups`: `~/.cups/client.conf` and
`~/.cups/lpoptions`.

### Dropbox

Okay, Dropbox is used by hundreds of millions of dummies so I won't expect
customizability on this front, but can't you move `~/.dropbox` to
`~/Library/Caches`?

### gist

By `gist` we mean [defunkt/gist](https://github.com/defunkt/gist).

Worst offender ever. It stores the OAuth token in `~/.gist`, making even
symlinking impractical.

Related PR: [`defunkt/gist#189`](https://github.com/defunkt/gist/pull/189).

### Heroku toolbelt

Issue: [`heroku/toolbelt#115`](https://github.com/heroku/toolbelt/issues/115).

### Keybase installer

Issue:
[`keybase/node-installer#65`](https://github.com/keybase/node-installer/issues/65).

### matplotlib

According to the
[FAQ](http://matplotlib.org/faq/environment_variables_faq.html#envvar-MPLCONFIGDIR),
matplotlib puts its config as well as caches in a single directory,
`MPLCONFIGDIR`, which is far from XDG conformant. Fortunately I rarely use
matplotlib and don't have any personal customizations, so the directory is
simply dropped to `$XDG_CACHE_HOME/matplotlib` (see `env/env.d/matplotlib`).

### mutt

See the `FILES` section of `man 1 mutt`: either `~/.muttrc` or
`~/.mutt/muttrc`.

### GNU Parallel

`$ENV{'HOME'} . "/.parallel/foo"` appears everywhere in source code.

### PyPI

According to
[the docs](https://docs.python.org/3/distutils/packageindex.html#pypirc), the
path of the config file has to be `~/.pypirc`.

### Shout

`path.resolve(this.HOME) + "/config"` is hard-coded in
[source code](https://github.com/erming/shout/blob/master/src/helper.js).

### tox

tox has no global configuration file, and unless one enforces one's own
preferences for `distshare` on other developers by setting `distshare` in
`tox.ini`, it defaults to `{homedir}/.tox/distshare`. See
[docs](http://codespeak.net/tox/config.html). (And the stupid thing is, I don't
really need to access build artifects between runs. I guess `~/.tox/distshare`
— serving no purpose at all in my case — has to be routinely wiped.)

### Travis client

Issue:
[`travis-ci/travis.rb#219`](https://github.com/travis-ci/travis.rb/issues/219).

### tmux

See the `FILEs` section of `man 1 tmux`: `~/.tmux.conf`.
