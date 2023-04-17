# nde

[![asciicast](https://raw.githubusercontent.com/jamespwilliams/nde/feccaff84707d39cfe3843ad5fe12992cd279979/nde.png)](https://asciinema.org/a/498457)

A modern neovim development environment, using
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) and
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter), that can
be spun up in a single command.

## Usage

First,
[install Nix](https://nix.dev/tutorials/install-nix) and [enable Nix
flakes](https://nixos.wiki/wiki/Flakes#Installing_flakes). Then:

```
nix develop github:jamespwilliams/nde
```

## Components

Currently, the following are provided (PRs welcome to add more):

**Editor**

* neovim
* nvim-lspconfig, plus configuration to use all of the **Supported Language
  Servers** listed below
* nvim-treesitter configuration for most languages (all those in nixpkgs'
  `pkgs.tree-sitter.allGrammars`)
* [bat.vim](https://github.com/jamespwilliams/bat.vim), my own Vim theme, which
  has extra rules for highlighting treesitter-parsed Go files
* [vim-sensible](https://github.com/tpope/vim-sensible), Tim Pope's set of sane
  defaults for Vim

**Supported Languages**

* Go (1.19.1) with [gopls](https://pkg.go.dev/golang.org/x/tools/gopls)
* Rust (1.63.0) with [rust-analyzer](https://rust-analyzer.github.io/)
* Python (3.10.6) with [pyright](https://github.com/microsoft/pyright)
* Perl (5.36.0) with [perl-language-server](https://github.com/FractalBoy/perl-language-server)
* Typescript (4.8.3) with [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)
* Lua with [lua-language-server](https://github.com/sumneko/lua-language-server)
* Vimscript with [vim-language-server](https://github.com/iamcco/vim-language-server)
* Terraform with [terraform-ls](https://github.com/hashicorp/terraform-ls)

## Optional installation steps

### Shell alias

For convenience, consider adding `alias nde='nix develop github:jamespwilliams/nde'`
to your `.bashrc` or equivalent:

**bash**:

```
echo alias nde=\'nix develop github:jamespwilliams/nde\' >> ~/.bashrc
```

**zsh**:

```
echo alias nde=\'nix develop github:jamespwilliams/nde\' >> ~/.zshrc
```

**fish**:

```
echo alias nde=\'nix develop github:jamespwilliams/nde\' >> ~/.config/fish/config.fish
```

### Start automatically in new shells

You can add `nix develop github:jamespwilliams/nde` to the very end of your
`.bashrc` (or equivalent), which will mean that you're always launched into the
environment when you start a new shell.

**bash**:

```
echo nix develop github:jamespwilliams/nde >> ~/.bashrc
```

**zsh**:

```
echo nix develop github:jamespwilliams/nde >> ~/.zshrc
```

**fish**:

```
echo nix develop github:jamespwilliams/nde >> ~/.config/fish/config.fish
```

## See also

There are quite a few other neovim IDE layers available:

* https://github.com/AstroNvim/AstroNvim
* https://www.lunarvim.org/

This project differs from those in two main ways:

* this project is more minimal
   * this is either a pro or a con, depending on your perspective
* this project uses Nix, which is reproducible and (arguably) cleaner
   * this is also either a pro or a con, depending on your perspective!
