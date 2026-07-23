{
  stdenv,
  lib,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "pixelmplus-ttf";
  version = "0.1";
  src = fetchzip {
    url = "https://github.com/itouhiro/PixelMplus/releases/download/v1.0.0/PixelMplus-20130602.zip";
    sha256 = "05fp3pnwd67p5mnlxvi2zyvsnblm1rymjhk0g4hw27v9ph2dgibd";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/pixelmfonts/
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/pixelmfonts/ {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Pixel M Plus Fonts";
    homepage = "https://github.com/itouhiro/PixelMplus";
    platforms = platforms.all;
  };
}
