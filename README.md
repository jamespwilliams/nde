# nde

[![asciicast](https://asciinema.org/a/498457.svg)](https://asciinema.org/a/498457)

A neovim development environment, that can be spun up in a single command.

First,
[install Nix](https://nix.dev/tutorials/install-nix) and [enable Nix
flakes](https://nixos.wiki/wiki/Flakes#Installing_flakes). Then:

```
nix develop github:jamespwilliams/nde
```

(originally based on https://github.com/jamespwilliams/neovim-go-nix-develop,
but extended to be much more opinionated, and languages (TODO)).

### Components

This derivation is tailored to my own needs. Currently, the following are
provided:

* go (at the time of writing, version 1.18.2)
* gopls (the official Go language server)
* neovim
* nvim-lspconfig
    * and configuration to get it to work with gopls
    * plus configuration to automatically fix up imports
* nvim-treesitter configuration for Go
* [bat.vim](https://github.com/jamespwilliams/bat.vim), my own Vim theme, which
  has extra rules for highlighting treesitter-parsed Go files
* [vim-sensible](https://github.com/tpope/vim-sensible), Tim Pope's set of sane
  defaults for Vim
