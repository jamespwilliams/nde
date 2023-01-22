{ pkgs ? import <nixpkgs> { } }:

let
  lspVimrcConfig = builtins.readFile ./base-neovim-config.lua;

  extraConfig = builtins.readFile ./extra-neovim-config.vim;

  vimrc = ''
    source ${pkgs.fzf.out}/share/vim-plugins/fzf/plugin/fzf.vim

    lua << EOF
    ${lspVimrcConfig}
    EOF

    ${extraConfig};
  '';

  # bat.vim syntax highlighting:
  bat-vim = pkgs.vimUtils.buildVimPlugin {
    name = "bat.vim";
    src = pkgs.fetchFromGitHub {
      owner = "jamespwilliams";
      repo = "bat.vim";
      rev = "e2319b07ed6e74cdd70df2be6e8bf066377e22f7";
      sha256 = "0bmlvziha1crk7x7p1yzdsb55bvpsj434sc28r7xspin9kfnd6y9";
    };
  };

  overriden-neovim =
    pkgs.neovim.override {
      configure = {
        customRC = vimrc;
        packages.packages = with pkgs.vimPlugins; {
          start = [
            bat-vim
            fzf-vim
            nvim-lspconfig
            (nvim-treesitter.withPlugins (
              plugins: pkgs.tree-sitter.allGrammars
            ))
            sensible
          ];
        };
      };
    };
in
with pkgs; mkShell {
  nativeBuildInputs = [
    fzf
    go_1_19
    gopls
    nodePackages.vim-language-server
    overriden-neovim
    ripgrep
    rnix-lsp
    sumneko-lua-language-server
    tmux

    python3
    pyright
  ];
}
