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
  curlWithGnuTls,
  xorg,
  fontconfig,
}:
stdenv.mkDerivation rec {
  pname = "audiothing-lines";
  version = "1.1";

  src = fetchzip {
    url = "https://audiothing.nyc3.cdn.digitaloceanspaces.com/Lines-${version}.tar.xz";
    sha256 = "03bwdj7s7qdg11sc8gj010zlvfz4dmwwf79lxg5mfvai8sg9c95z";
  };

  buildInputs = [
    libatomic_ops
    alsa-lib
    freetype
    fontconfig
    libjack2
    libGL
    curlWithGnuTls
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
    cp -r "$src/Plugins/Lines.vst3" $out/lib/vst3/audiothing

    mkdir -p $out/lib/vst/audiothing
    cp -r "$src/Plugins/Lines.so" $out/lib/vst/audiothing

    mkdir -p $out/lib/clap/audiothing
    cp -r "$src/Plugins/Lines.clap" $out/lib/clap/audiothing

    mkdir -p $out/opt/AudioThing/LinesPresets/
    cp -r $src/Presets/Lines $out/opt/AudioThing/LinesPresets

    runHook postInstall
  '';

  postFixup = ''
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst3/audiothing/Lines.vst3/Contents/x86_64-linux/Lines.so
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/clap/audiothing/Lines.clap
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst/audiothing/Lines.so
  '';

  meta = with lib; {
    description = "audiothing Lines synth plugin";
    homepage = "https://audiothing.net/";
    platforms = platforms.x86_64;
  };
}
