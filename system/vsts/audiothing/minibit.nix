{
  stdenv,
  fetchzip,
  lib,
  autoPatchelfHook,
  copyDesktopItems,
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
  pname = "audiothing-minibit";
  version = "1.7";

  src = fetchzip {
    url = "https://audiothing.nyc3.cdn.digitaloceanspaces.com/miniBit-${version}.tar.xz";
    sha256 = "130x9rlmprkvfz5b653qz8bj7b8sgibaji8cc4y92qj7sp73vzd8";
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

  desktopItems = [
    "$src/Plugins/miniBit.desktop"
  ];

  nativeBuildInputs = [makeWrapper autoPatchelfHook copyDesktopItems];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  installPhase = ''

    runHook preInstall

    mkdir -p $out/lib/vst3/audiothing
    cp -r "$src/Plugins/miniBit.vst3" $out/lib/vst3/audiothing

    mkdir -p $out/lib/vst/audiothing
    cp -r "$src/Plugins/miniBit.so" $out/lib/vst/audiothing

    mkdir -p $out/lib/clap/audiothing
    cp -r "$src/Plugins/miniBit.clap" $out/lib/clap/audiothing

    mkdir -p $out/opt/AudioThing/miniBitPresets/
    cp -r $src/Presets/miniBit $out/opt/AudioThing/miniBitPresets

    mkdir -p $out/bin $out/opt/AudioThing
    install -Dm755 $src/Plugins/miniBit $out/bin
    ln -s $out/bin/miniBit $out/opt/AudioThing

    mkdir -p $out/share/pixmaps $out/opt/AudioThing
    install -Dm444 $src/Plugins/miniBit.png $out/share/pixmaps/miniBit.png
    ln -s $src/Plugins/miniBit.png $out/opt/AudioThing

    runHook postInstall
  '';

  wrapMiniBit = ''
    # make our path
    ABANDON_ALL_HOPE="$HOME/.local/share/AudioThing/Presets/miniBit"
    mkdir -p $ABANDON_ALL_HOPE

    # copy our presets in there
    # since we want users to overwrite default presets, we use -i "no clobber"
    cp -r -i --no-preserve=mode,ownership ${placeholder "out"}/opt/AudioThing/miniBitPresets/miniBit/ $ABANDON_ALL_HOPE
  '';

  postFixup = ''
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst3/audiothing/miniBit.vst3/Contents/x86_64-linux/miniBit.so
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/clap/audiothing/miniBit.clap
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst/audiothing/miniBit.so

    wrapProgram $out/bin/miniBit \
        --run "$wrapMiniBit" \
        --suffix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath buildInputs}"
  '';

  meta = with lib; {
    description = "audiothing miniBit synth plugin";
    homepage = "https://audiothing.net/";
    platforms = platforms.x86_64;
  };
}
