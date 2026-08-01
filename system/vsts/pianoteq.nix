{
  lib,
  stdenv,
  autoPatchelfHook,
  alsa-lib,
  fontconfig,
  freetype,
  libGL,
  libX11,
  libXext,
  libXcursor,
  libXinerama,
  libXrandr,
  requireFile,
}:
stdenv.mkDerivation {
  pname = "pianoteq";
  version = "9.2.1";

  # Ask the user to provide the file manually
  src = requireFile {
    name = "pianoteq_setup_v921.tar.xz";
    sha256 = "0ypfhd7syhla6y0xf4w9h4h3nfj2flgsjm73j239jxxvgjcri0l8";
    message = ''
      Pianoteq 9 requires a proprietary setup archive.
      1. Download 'pianoteq_setup_v912.tar.xz' from your Modartt account.
      2. Add it to your Nix store by running:
         nix-prefetch-url file:///absolute/path/to/pianoteq_setup_v912.tar.xz
      3. Copy the resulting hash and update the 'sha256' field in this flake.nix.
    '';
  };

  # Tell Nix's unpackPhase to unpack into the current directory
  # since the archive lacks a single top-level wrapper folder.
  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    libGL
    stdenv.cc.cc.lib
    libX11
    libXext
    libXcursor
    libXinerama
    libXrandr
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cd "x86-64bit"

    mkdir -p $out/bin
    cp "Pianoteq 9" $out/bin/pianoteq9

    mkdir -p $out/lib/lv2
    cp -r "Pianoteq 9.lv2" $out/lib/lv2/

    mkdir -p $out/lib/vst3
    cp -r "Pianoteq 9.vst3" $out/lib/vst3/

    runHook postInstall
  '';

  meta = {
    description = "Pianoteq 9 - Physical modelling piano synthesizer";
    homepage = "https://www.modartt.com/pianoteq";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "pianoteq9";
  };
}
