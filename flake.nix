{
  description = "Home Manager module and development shell for Mythos-404/nvimdots";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      homeManagerModules.default = ./nixos;

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            name = "nvimdots";
            NVIMDOTS_TOOL_BACKEND = "system";

            packages = with pkgs; [
              # Editor and repository helpers
              neovim
              git
              ripgrep
              fd
              fzf
              tree-sitter
              just
              nixfmt

              # Language servers (HTML and JSON share vscode-langservers-extracted)
              bash-language-server
              clang-tools
              vscode-langservers-extracted
              lua-language-server
              basedpyright
              gopls
              rust-analyzer

              # Formatters and linters; clang-tools also supplies clang-format
              shfmt
              prettierd
              gotools # supplies goimports
              gofumpt
              ruff
              stylua
              yamlfmt
              rustfmt
              gawk
              actionlint
              shellcheck

              # Debuggers and language runtimes
              vscode-extensions.vadimcn.vscode-lldb.adapter
              delve
              (python3.withPackages (ps: [
                ps.debugpy
                ps.pynvim
              ]))
              nodejs
              go
              rustc
              cargo
            ];
          };
        }
      );
    };
}
