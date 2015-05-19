I'm striving to declutter my home directory (following [XDG Base Directory Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html)) and put configs into version control. This is a work in progress, and the configs of more projects will be factored into this repo in the near future, probably including `zsh`/`bash` and `emacs` customizations (which are fundamental) as well as `cron` maintenance scripts.

## Getting started

```zsh
git clone https://github.com/zmwangx/dotfiles ~/.config

# Set up global environment.
source ~/.config/env

# Create data and cache dirs (some programs are not smart enough to
# create directories themselves, and nonexistent directories are
# silently ignored). Also, change modes of config, data, and cache
# directories to 700 for security.
~/.config/dirs

# Link some of the offenders (discussed below) to $HOME.
~/.config/link
```

Also, `source ~/.config/env` should go into `.bashrc`, `.zshenv`, and its equivalent should go into the rc for other noninteractive shells (the `export` builtin is required and the `export var=val` syntax must be supported).

Note that config files with credentials have been excluded from the directory, and their `.template` counterparts have been committed in. Replace the redacted credentials (generally in the form `XXXXXX`) with the actual values.

## Offenders

There are projects that insist on living in the home directory and are either hard or impossible to factor. Here is a partial list:

* Atom. Everything from configs to packages to caches (I suppose `.atom/storage` is some sort of cache) live in `~/.atom`.

* colordiff. `"$ENV{HOME}/.colordiffrc"` is the hard-coded per-user config file path in the Perl source.

* CUPS. See the `FILES` section of `man 1 cups`: `~/.cups/client.conf` and `~/.cups/lpoptions`. No customization available.

* Dropbox. `.dropbox` is always there.

* GnuPG. Configs, data, and even sockets all live in `$GNUPGHOME`, making it hard to follow the base directory spec; worse yet, GPGTools (the OS X GUI suite) won't work if `~/.gnupg` is not present, even when `$GNUPGHOME` is set.

* Heroku toolbelt. I see no way to customize the path `~/.heroku`. See [heroku/toolbelt#115](https://github.com/heroku/toolbelt/issues/115).

* matplotlib. According to the [FAQ](http://matplotlib.org/faq/environment_variables_faq.html#envvar-MPLCONFIGDIR), matplotlib puts its config as well as caches in a single directory, `MPLCONFIGDIR`, which is far from XDG conformant. Fortunately I rarely use matplotlib and don't have any personal customizations, so the directory is simply dropped to `$XDG_CACHE_HOME/matplotlib` (see `env/env.d/matplotlib`).

* mutt. The `FILES` section of `man 1 mutt` says that the user configuration file is either `~/.muttrc` or `~/.mutt/muttrc`.

* GNU Parallel. `$ENV{'HOME'} . "/.parallel/foo"` appears everywhere in the Perl source.

* Prezto. Prezto's init script explicitly loads from `${ZDOTDIR:-$HOME}/.zprezto/modules/`.

* PyPI. According to [the docs](https://docs.python.org/3/distutils/packageindex.html#pypirc), the path of the config file has to be `$HOME/.pypirc`.

* RVM. `.rvm` contains all the binaries, so it doesn't fit nicely anywhere. I'll just leave it alone in `$HOME`. (By the way, beware of RVM's stupid install script, which by default litters your every single shell init script, even nonexisting ones — `.mkshrc` WTF?)

* tox. tox has no global configuration file, and unless one enforces one's own preferences for `distshare` on other developers by setting `distshare` in `tox.ini`, it defaults to `{homedir}/.tox/distshare`. See [docs](http://codespeak.net/tox/config.html). (And the stupid thing is, I don't really need to access build artifects between runs. I guess `~/.tox/distshare` — serving no purpose at all in my case — has to be routinely wiped.)

* Travis CI CLI client. [#219](https://github.com/travis-ci/travis.rb/issues/219) is precisely about the `$XDG_CONFIG_HOME` issue. No word thus far.

* tmux. The `FILEs` section of `man 1 tmux` makes it clear that `~/.tmux.conf` is not customizable.

* Z shell. In principle we can use the `ZDOTDIR` environment variable. In practice, there's no way to set the per-user `ZDOTDIR` before `${ZDOTDIR:-$HOME}/.zshenv` is read except by directly hacking from `launchd`. Moreover, even then the runcoms need to be dot prefixed within `${ZDOTDIR}`.
