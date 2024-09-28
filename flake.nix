{
  description =
    "golang development environment (neovim + nvim_lsp + treesitter)";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = nixpkgs.legacyPackages.${system};

        vimrc = ''
          source ${pkgs.fzf.out}/share/vim-plugins/fzf/plugin/fzf.vim

          lua << EOF
          ${builtins.readFile ./base-neovim-config.lua}
          EOF

          ${builtins.readFile ./extra-neovim-config.vim};
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

        overriden-neovim = pkgs.neovim.override {
          configure = {
            customRC = vimrc;
            packages.packages = with pkgs.vimPlugins; {
              start = [
                bat-vim
                fzf-vim
                nvim-lspconfig
                (nvim-treesitter.withPlugins
                  (plugins: pkgs.tree-sitter.allGrammars))
                rust-tools-nvim
                sensible
              ];
            };
          };
        };

      in with pkgs; {
        devShell = mkShell {
          nativeBuildInputs = [
            fzf
            go
            gopls
            nodePackages.vim-language-server
            overriden-neovim
            ripgrep
            sumneko-lua-language-server
            tmux

            python3
            pyright

            cargo
            rustc
            rustfmt
            rust-analyzer

            perl
            perlPackages.PLS

            nodePackages.typescript
            nodePackages.typescript-language-server

            terraform
            terraform-ls
          ];
        };

      });
}
