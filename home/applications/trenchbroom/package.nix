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
in
appimageTools.wrapType2 {
  pname = "trenchbroom";
  version = "2026.1";
  src = "${srcZipped}/TrenchBroom.AppImage";
}
