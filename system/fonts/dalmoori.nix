{
  stdenvNoCC,
  lib,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "dalmoori-ttf";
  version = "0.200";

  src = fetchzip {
    url = "https://github.com/RanolP/dalmoori-font/releases/download/v0.200/dalmoori-font.zip";
    sha256 = "1f989h8z004z4mmlbmjnr8vj6pq8l472dj6vx0bl3ph5dapg0pc3";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/dalmoori
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/dalmoori/ {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dalmoori Fonts";
    homepage = "https://ranolp.github.io/dalmoori-font/";
    platforms = platforms.all;
  };
}
