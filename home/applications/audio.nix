{ pkgs, ... }:
{
  services.flatpak.packages = [
    "com.rosegardenmusic.rosegarden"
  ];

  xdg.configFile."yabridgectl/config.toml".source = ./yabridge/config.toml;

  home.packages = with pkgs; [
    audacity
    kdePackages.k3b
    strawberry
    kid3-cli
    exiftool

    openutau
    lilypond
  ];
}
