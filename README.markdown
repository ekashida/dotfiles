# dotfiles

This repo is more than a collection of dotfiles--it contains all the things I
need to get a general development environment up and running on a mac.

```sh
git clone git@github.com:ekashida/dotfiles.git
```

## install packages

1. Install [brew][]
1. Install [brew][] bottles
  - `brew install ag`
  - `brew install fish`
  - `brew install git`
  - `brew install tidy-html5`
  - `brew install vim`
  - `brew install n`
1. Install [neovim][]
  1. `brew tap neovim/neovim`
  1. `brew install --HEAD neovim`

## install configs

1. Follow on-screen instructions after the brew install to make [fish][] the default shell
1. `./install.fish` (in dotfiles repo)


[brew]: http://brew.sh/
[fish]: http://fishshell.com/
[neovim]: https://neovim.io/
