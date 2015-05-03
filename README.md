I'm striving to declutter my home directory (following [XDG Base Directory Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html)) and put configs into version control. This is a work in progress, and the configs of more projects will be factored into this repo in the near future, probably including `zsh`/`bash` and `emacs` customizations (which are fundamental).

## Getting started

```zsh
git clone https://github.com/zmwangx/dotfiles ~/.config
source ~/.config/env/env
~/.config/link # link some of the offenders (discussed below) to $HOME
```

Also, `source ~/.config/env/env` should go into `.bashrc`, `.zshenv`, and its equivalent should go into the rc for other noninteractive shells (the `export` builtin is required).

## Offenders

There are projects that insist on living in the home directory and either hard or impossible to factor. Here is a partial list:

* Atom. Everthing from configs to packages to caches (I suppose `.atom/storage` is some sort of cache) live in `~/.atom`.

* `colordiff`. `"$ENV{HOME}/.colordiffrc"` is the hard-coded per-user config file path in the Perl source code.

* CUPS. See the `FILES` section of `man 1 cups`: `~/.cups/client.conf` and `~/.cups/lpoptions`. No customization available.

* Dropbox. `.dropbox` is always there.

* GnuPG. Configs, data, and even sockets all live in `$GNUPGHOME`, making it hard to follow the base directory spec; worse yet, GPGTools (the OS X GUI suite) won't work if `~/.gnupg` is not present, even when `$GNUPGHOME` is set.
