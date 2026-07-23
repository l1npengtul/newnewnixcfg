{
  lib,
  stdenv,
  fetchFromGitHub,
  clap,
  cairo,
  libX11,
  libXcomposite,
  libXcursor,
  libXinerama,
  libXrandr,
  libXtst,
  libXdmcp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sfzq";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "stevefolta";
    repo = finalAttrs.pname;
    rev = "1d99193bd0e5fbbf37b4b3d6ba56232f95ec48e0";
    hash = "sha256-kkBkv8DNIGvdDKhZAkXpLfxxVUjQFPuDWYsfb5XCJd8=";
  };

  buildInputs = [
    clap
    cairo
    libX11
    libXcomposite
    libXcursor
    libXinerama
    libXrandr
    libXtst
    libXdmcp
  ];

  patches = [
    ./cstdint.patch
  ];

  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXtst"
      "-lXdmcp"
    ]
  );

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/clap
    cp *.clap $out/lib/clap


    runHook postInstall
  '';
})
