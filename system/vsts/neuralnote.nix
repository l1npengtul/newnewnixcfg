{
  stdenv,
  fetchzip,
  lib,
  autoPatchelfHook,
  makeWrapper,
  libatomic_ops,
  alsa-lib,
  freetype,
  libjack2,
  libGL,
  curl,
  xorg,
  fontconfig,
}:
stdenv.mkDerivation rec {
  pname = "neuralnote";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/DamRsn/NeuralNote/releases/download/v1.1.0/NeuralNote_Standalone_Linux.zip";
    sha256 = "sha256-Yi7Fj6kqTRAdwACUPvQwc5mqUMtkejkzGQCSLeWV8uU=";
  };

  buildInputs = [
    libatomic_ops
    alsa-lib
    freetype
    fontconfig
    libjack2
    libGL
    curl
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrender
    xorg.libXrandr
    xorg.libXdmcp
    xorg.libXtst
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [makeWrapper autoPatchelfHook];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    install -m 755 -D $src/NeuralNote $out/bin/NeuralNote

    runHook postInstall
  '';

  postFixup = let
    libPath = lib.makeLibraryPath [
      libatomic_ops
      alsa-lib
      freetype
      fontconfig
      libjack2
      libGL
      curl
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXinerama
      xorg.libXrender
      xorg.libXrandr
      xorg.libXdmcp
      xorg.libXtst
    ];
  in ''
    wrapProgram $out/bin/NeuralNote \
      --set LD_LIBRARY_PATH ${libPath}
  '';

  meta = with lib; {
    description = "neuralnote";
    homepage = "https://github.com/DamRsn/NeuralNote";
    mainProgram = "NeuralNote";
    platforms = platforms.x86_64;
  };
}
