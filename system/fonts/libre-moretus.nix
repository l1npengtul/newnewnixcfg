{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "libre-moretus";
  version = "0-unstable-06-05-2017";

  src = fetchFromGitHub {
    owner = "davelab6";
    repo = "libre-moretus";
    rev = "f53aeed8e3afc48f49f315d842ea256891879748";
    hash = "sha256-e5CjO14BCCFkkHnspTlsZGTbxsHCjSaYhUksjSA1TA0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/libre-moretus
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/libre-moretus/ {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "A revival of the Plantin typeface";
    homepage = "https://github.com/davelab6/libre-moretus";
    platforms = platforms.all;
  };
}
