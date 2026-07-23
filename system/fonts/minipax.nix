{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "minipax";
  version = "0-unstable-24-08-2024";

  src = fetchFromGitHub {
    owner = "ronotypo";
    repo = "Minipax";
    rev = "5d03c3b8171e760b21e399ae24af64f0d937f4ec";
    hash = "sha256-DebpjB5iZsY3QT13XHRn1/jElBLP5mGYX+6Um2ZJQNk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/minipax
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/minipax/ {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "A typeface inspired by the novel 1984, from George Orwell";
    homepage = "https://github.com/ronotypo/Minipax";
    platforms = platforms.all;
  };
}
