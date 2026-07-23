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
  pname = "audiothing-noises";
  version = "1.2.1";

  src = fetchzip {
    url = "https://audiothing.nyc3.cdn.digitaloceanspaces.com/38042111/Noises-${version}.tar.xz";
    sha256 = "0hsjwdh2543743w3l7rwsyhdzzfw7sf3y2lph5qm1npf98vkgcxg";
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
    cp -r "$src/Plugins/Noises.vst3" $out/lib/vst3/audiothing

    mkdir -p $out/lib/vst/audiothing
    cp -r "$src/Plugins/Noises.so" $out/lib/vst/audiothing

    mkdir -p $out/lib/clap/audiothing
    cp -r "$src/Plugins/Noises.clap" $out/lib/clap/audiothing

    mkdir -p $out/opt/AudioThing/NoisesPresets/
    cp -r $src/Presets/Noises $out/opt/AudioThing/NoisesPresets

    mkdir -p $out/opt/AudioThing/NoisesSamples
    cp -r $src/Samples/Noises $out/opt/AudioThing/NoisesSamples

    runHook postInstall
  '';

  postFixup = ''
    # make our path
    ABANDON_ALL_HOPE="$HOME/.local/share/AudioThing/Presets/Noises"
    mkdir -p $ABANDON_ALL_HOPE

    # copy our presets in there
    # since we want users to overwrite default presets, we use -i "no clobber"
    cp -r -i --no-preserve=mode,ownership ${placeholder "out"}/opt/AudioThing/NoisesPresets/Noises/ $ABANDON_ALL_HOPE

    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst3/audiothing/Noises.vst3/Contents/x86_64-linux/Noises.so
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/clap/audiothing/Noises.clap
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst/audiothing/Noises.so
  '';

  meta = with lib; {
    description = "audiothing Noises synth plugin";
    homepage = "https://audiothing.net/";
    platforms = platforms.x86_64;
  };
}
