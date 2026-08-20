{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    vobcopy
    (makemkv.overrideAttrs {
      srcs = [
        "${inputs.randomshit}/makemkv-oss-1.18.4.tar.gz"
        "${inputs.randomshit}/makemkv-bin-1.18.4.tar.gz"
      ];
    })
    vlc
    ffmpeg-full
    mkvtoolnix
  ];
}
