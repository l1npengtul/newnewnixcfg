{
  stdenvNoCC,
  lib,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "rainyhearts-ttf";
  version = "0.1";
  src = ./rainyhearts.zip;

  unpackPhase = ''
    runHook preUnpack

    ${unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/rainyhearts
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/rainyhearts/ {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rainy Hearts";
    homepage = "created by Camellina - tr.camellina@gmail.com";
    platforms = platforms.all;
  };
}
