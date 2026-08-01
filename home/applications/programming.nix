{ pkgs, ... }:
let
  create-rust-devshell = pkgs.writeShellScriptBin "create-rust-devshell" ''
    set -euxo pipefail

    git init
    git branch -M senpai
    wget https://gist.githubusercontent.com/l1npengtul/b686a79d81c5c14b9c3b988bc987c399/raw/6e4a961644d8fee049a821eecf0eb003f7dc72e2/flake.nix
    git add flake.nix
    echo "use flake" > .envrc
  '';
in
{
  home.packages = with pkgs; [
    ghidra-bin
    gdb
    # hex editor
    okteta

    kdiff3

    gram

    marksman
    eslint
    zuban
    typescript-language-server
    lua
    luarocks
    luaformatter

    create-rust-devshell
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fresh-editor = {
    enable = true;
    settings = {
      editor = {
        line_numbers = true;
        tab_size = 4;
      };

      theme = "https://github.com/sinelaw/fresh-plugins#themes/catppuccin/latte";

      languages = {
        rust = {
          enabled = true;
          format_on_save = true;
          command = "rust-analyzer";
          initialization_options = {
            checkOnSave = true;
          };
        };
      };

      plugins = {
        color-highlighter = {
          enabled = true;
        };
        todo-highlighter = {
          enabled = true;
        };
      };
    };
  };

  xdg.configFile."gram/settings.jsonc".source = ./gram/settings.jsonc;
  xdg.configFile."gram/themes/settings.jsonc".source = ./gram + "/Soft colors.json";
}
