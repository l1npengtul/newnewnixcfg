{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libGL,
  expat,
  xdg-utils,
  zlib-ng,
  zlib,
  fontconfig,
  libXrender,
  libXtst,
  xinput,
  alsa-lib,
  makeWrapper,
  dpkg,
  makeDesktopItem,
}: let
  desktopItem = makeDesktopItem {
    name = "RecStar";
    desktopName = "RecStar";
    genericName = "UTAU Reclist Recorder";
    comment = "UTAU Reclist Recorder";
    icon = "RecStar";
    terminal = false;
    type = "Application";
    categories = ["Audio" "Music" "Utility"];
    keywords = ["recorder" "utau" "reclist"];
    exec = "RecStar";
  };
in
  stdenv.mkDerivation rec {
    pname = "recstar";
    version = "1.1.2";

    src = fetchurl {
      url = "https://github.com/sdercolin/recstar/releases/download/1.1.2/recstar-1.1.2-amd64.deb";
      sha256 = "0xhx78121xkmbisvs9mpaasrpwq1lsrrn5xmik1vl6nsp6xpf7wn";
    };
    sourceRoot = ".";
    unpackCmd = "dpkg-deb -x recstar-1.1.2-amd64.deb .";

    buildInputs = [libGL expat stdenv.cc.cc.lib xdg-utils zlib-ng zlib fontconfig libXrender libXtst xinput xinput alsa-lib makeWrapper];

    nativeBuildInputs = [autoPatchelfHook dpkg];

    installPhase = ''
      mkdir -p $out/opt/recstar
      mv root/opt/recstar $out/opt/

      install -Dm644 $out/opt/recstar/lib/RecStar.png -t $out/share/pixmaps

      mkdir -p $out/bin
      ln -s $out/opt/recstar/bin/RecStar $out/bin/RecStar

      mkdir -p $out/share/applications/
      ln -s ${desktopItem}/share/applications/* $out/share/applications
    '';

    meta = with lib; {
      description = "UTAU Reclist recorder";
      license = licenses.asl20;
      mainProgram = "RecStar";
      platforms = ["x86_64-linux"];
    };
  }
