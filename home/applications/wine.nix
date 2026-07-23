{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protontricks
    winetricks
    wineasio
    protonup-qt
    protonup-rs
    protonup-ng
    protonplus
    bottles
  ];
}
