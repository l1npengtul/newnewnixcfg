{ inputs, pkgs, ... }:
let
  randomshit = builtins.toString inputs.randomshit;
in
{
  services.flatpak.packages = [
    "com.rosegardenmusic.rosegarden"
  ];

  xdg.configFile."yabridgectl/config.toml".source = ./yabridge/config.toml;

  home.file.".local/share/Modartt/Pianoteq/Addons/bells.ptq".source = "${randomshit}/bells.ptq";
  home.file.".local/share/Modartt/Pianoteq/Addons/KIViR.ptq".source = "${randomshit}/KIViR.ptq";

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
