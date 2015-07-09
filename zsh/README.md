To install (i.e., symlink) the runcoms and Prezto to `HOME`, simply run the
`setup` script in the root of this repository (which also installs other things
as it sees fit).

The following runcom customizations are possible:

* Local additions: each runcom (`zshenv`, `zprofile`, `zshrc`, `zlogin` and
  `zlogout`) accepts a local addition in this directory:

  * `perhostenv`;
  * `perhostprofile`;
  * `perhostrc`;
  * `perhostlogin`;
  * `perhostlogout`.

  Each of these per-host additions (if any) is sourced right *after* its
  corresponding default runcom, i.e., `perhostenv` right after `zshenv`, etc.

* Local overrides: it is possible to override a runcom altogether. This is done
  by the following (still in this directory):

  * `zshenv_override`;
  * `zprofile_override`;
  * `zshrc_override`;
  * `zlogin_override`;
  * `zlogout_override`.

  Each of these per-host overrides (if any) is sourced right *before* the
  corresponding default runcom, and the default is then *skipped* if the return
  value of the `override` is 0.

  Example usage: to redirect `HOME` to another filesystem, one may use the
  following `zshenv_override`:

  ```zsh
  if [[ -e /farmshare/user_data/zmwang ]]; then
      export HOME=/farmshare/user_data/zmwang
      source $HOME/.zshenv
      return 0
  else
      return 1
  fi
  ```

  This way, if the target filesystem is available, then the `zshenv` in the
  target filesystem is sourced, while the one in the current filesystem is
  not. On the other hand, if the target filesystem is not available, then the
  env is still set by the `zshenv` in the current filesystem.
