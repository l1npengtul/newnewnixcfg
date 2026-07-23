{
  stdenv,
  fetchzip,
  lib,
  autoPatchelfHook,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "socalabs";
  version = "0.1";

  src = fetchzip {
    url = "https://socalabs.com/files/get.php?id=All_Linux.zip";
    sha256 = "091vsrfxs6ywd5nkhzca1kc8iiraqswxllbp1ldcxafv44qhnps7";
    stripRoot = false;
  };

  buildInputs = [stdenv.cc.cc.lib pkgs.libatomic_ops pkgs.alsa-lib pkgs.freetype pkgs.libGL pkgs.curl];

  nativeBuildInputs = [autoPatchelfHook];

  installPhase = ''

    runHook preInstall

    mkdir -p $out/lib64/vst3/socalabs
    cp -r $src/vst3/* $out/lib64/vst3/socalabs

    mkdir -p $out/lib64/vst/socalabs
    cp -r $src/vst/* $out/lib64/vst/socalabs

    mkdir -p $out/lib64/lv2/socalabs
    cp -r $src/lv2/* $out/lib64/lv2/socalabs

    runHook postInstall

  '';

  meta = with lib; {
    description = "socalabs plugins";
    homepage = "https://socalabs.com/";
    platforms = platforms.x86_64;
  };
}
