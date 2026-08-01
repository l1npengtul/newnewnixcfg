{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protontricks
    winetricks
    wineasio
  ];
}
