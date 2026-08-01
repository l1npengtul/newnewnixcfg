{
  lib,
  appimageTools,
  fetchzip,
}:
let
  srcZipped = fetchzip {
    url = "https://github.com/TrenchBroom/TrenchBroom/releases/download/v2026.1/TrenchBroom-Linux-x86_64-v2026.1-Release.zip";
    hash = "sha256-BUNxtM7VJ4L6upg154RnGT4Dd4s1X+ZdJ0Tjov0tmrw=";
    stripRoot = false;
  };

  pname = "trenchbroom";
  version = "2026.1";
  src = "${srcZipped}/TrenchBroom.AppImage";

  appImageContents = appimageTools.extract {
    inherit src version pname;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appImageContents}/trenchbroom.desktop $out/share/applications/trenchbroom.desktop
    install -m 444 -D ${appImageContents}/trenchbroom.png $out/share/icons/hicolor/512x512/apps/trenchbroom.png
  '';

  meta = {
    description = "Modern cross-platform level editor for Quake-engine based games";
    homepage = "https://github.com/TrenchBroom/TrenchBroom";
    downloadPage = "https://github.com/TrenchBroom/TrenchBroom/releases";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ l1npengtul ];
    platforms = [ "x86_64-linux" ];
  };
}
