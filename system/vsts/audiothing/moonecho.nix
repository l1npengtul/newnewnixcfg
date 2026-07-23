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
  pname = "audiothing-moonecho";
  version = "1.0";

  src = fetchzip {
    url = "https://audiothing.nyc3.cdn.digitaloceanspaces.com/MoonEcho-${version}.tar.xz";
    sha256 = "0jx8lvcc1lry62fkgy498nb41i39xjffjsm4jqaa5c88z63b15m8";
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

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3/audiothing
    cp -r "$src/Plugins/MoonEcho.vst3" $out/lib/vst3/audiothing

    mkdir -p $out/lib/vst/audiothing
    cp -r "$src/Plugins/MoonEcho.so" $out/lib/vst/audiothing

    mkdir -p $out/lib/clap/audiothing
    cp -r "$src/Plugins/MoonEcho.clap" $out/lib/clap/audiothing

    mkdir -p $out/opt/AudioThing/MoonEchoPresets/
    cp -r $src/Presets/MoonEcho $out/opt/AudioThing/MoonEchoPresets

    runHook postInstall
  '';

  postFixup = ''
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst3/audiothing/MoonEcho.vst3/Contents/x86_64-linux/MoonEcho.so
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/clap/audiothing/MoonEcho.clap
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst/audiothing/MoonEcho.so
  '';

  meta = with lib; {
    description = "audiothing MoonEcho synth plugin";
    homepage = "https://audiothing.net/";
    platforms = platforms.x86_64;
  };
}
