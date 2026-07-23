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
  pname = "audiothing-fog-convolver2";
  version = "2.3";

  src = fetchzip {
    url = "https://audiothing.nyc3.cdn.digitaloceanspaces.com/39301751/FogConvolver-${version}.tar.xz";
    hash = "sha256-BjHCCvaZBMR2Gx1M8FKuNYa349eu7zGGFmTM4ZLPIB8=";
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
    cp -r "$src/Plugins/FogConvolver2.vst3" $out/lib/vst3/audiothing

    mkdir -p $out/lib/vst/audiothing
    cp -r "$src/Plugins/FogConvolver2.so" $out/lib/vst/audiothing

    mkdir -p $out/lib/clap/audiothing
    cp -r "$src/Plugins/FogConvolver2.clap" $out/lib/clap/audiothing

    mkdir -p $out/opt/AudioThing/FogConvolver2Presets/
    cp -r $src/Presets/FogConvolver2 $out/opt/AudioThing/FogConvolver2Presets

    mkdir -p $out/opt/AudioThing/FogConvolver2Samples
    cp -r $src/Samples/FogConvolver2 $out/opt/AudioThing/FogConvolver2Samples

    runHook postInstall
  '';

  postFixup = ''
    # make our path
    ABANDON_ALL_HOPE="$HOME/.local/share/AudioThing/Presets/FogConvolver2"
    mkdir -p $ABANDON_ALL_HOPE

    # copy our presets in there
    # since we want users to overwrite default presets, we use -i "no clobber"
    cp -r -i --no-preserve=mode,ownership ${placeholder "out"}/opt/AudioThing/FogConvolver2Presets/FogConvolver2/ $ABANDON_ALL_HOPE

    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst3/audiothing/FogConvolver2.vst3/Contents/x86_64-linux/FogConvolver2.so
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/clap/audiothing/FogConvolver2.clap
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst/audiothing/FogConvolver2.so
  '';

  meta = with lib; {
    description = "audiothing FogConvolver2 synth plugin";
    homepage = "https://audiothing.net/";
    platforms = platforms.x86_64;
  };
}
