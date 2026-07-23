{ pkgs, ... }:
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
