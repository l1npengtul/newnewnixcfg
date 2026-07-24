{ pkgs, ... }:
{
  powerManagement = {
      enable = true;
      powertop.enable = true;
    };

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  environment.systemPackages = with pkgs; [
    vim
    micro
    wget
    curl
    git
  ];

  environment.pathsToLink = [
    "/bin"
    "/lib"
    "/lib64"
    "/etx/xdg"
    "/sbin"
    "/share/applications"
    "/share/emacs"
    "/share/hunspell"
    "/share/nano"
    "/share/org"
    "/share/themes"
    "/share/vim-plugins"
    "/share/vulkan"
    "/share/kservices5"
    "/share/kservicetypes5"
    "/share/kxmlgui5"
    "/share/systemd"
    "/share/thumbnailers"
    "/share/xdg-desktop-portal"
    "/share/qemu"
    "/sys"
  ];

  boot = {
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    optimise.automatic = true;
  };
  security.polkit.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
}
