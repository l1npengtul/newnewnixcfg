{
  inputs,
  pkgs,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user.email = inputs.shhh.email;
        user.name = "l1npengtul";
      };
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
        echo ""
        echo "SAKANA!!!!"
        starship init fish | source
      '';
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf.src;
        }
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "pisces";
          src = pkgs.fishPlugins.pisces.src;
        }
      ];
    };
  };

  home.packages = with pkgs; [
    fzf
    grc
  ];

  services.ssh-agent.enable = true;
}
