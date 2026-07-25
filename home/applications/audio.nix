{ pkgs, ... }:
{
  services.flatpak.packages = [
    "com.rosegardenmusic.rosegarden"
  ];

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
