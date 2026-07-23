{ pkgs, lib, ... }:
let
  version = "7.0.0";
  pname = "rpgmtranslate";

  src = pkgs.fetchurl {
    url = "https://github.com/RPG-Maker-Translation-Tools/rpgmtranslate/releases/download/v7.0.0/rpgmtranslate_7.0.0_amd64.AppImage";
    hash = "sha256-uz0xNjW3MKbiffVAx5tAfZbtyVKX3KjsmyvCJcKqvtE=";
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;
}
