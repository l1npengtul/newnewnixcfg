{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vobcopy
    makemkv
    vlc
    ffmpeg-full
  ];
}
