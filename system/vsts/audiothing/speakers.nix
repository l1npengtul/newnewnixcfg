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
  pname = "audiothing-speakers";
  version = "1.3";

  src = fetchzip {
    url = "https://audiothing.nyc3.cdn.digitaloceanspaces.com/29921240/Speakers-${version}.tar.xz";
    sha256 = "0j5qyvyl2x5i631cgjziybm47p0p0ncpzsm39vca7v883bdrajn3";
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
    cp -r "$src/Plugins/Speakers.vst3" $out/lib/vst3/audiothing

    mkdir -p $out/lib/vst/audiothing
    cp -r "$src/Plugins/Speakers.so" $out/lib/vst/audiothing

    mkdir -p $out/lib/clap/audiothing
    cp -r "$src/Plugins/Speakers.clap" $out/lib/clap/audiothing

    mkdir -p $out/opt/AudioThing/SpeakersPresets/
    cp -r $src/Presets/Speakers $out/opt/AudioThing/SpeakersPresets

    runHook postInstall
  '';

  postFixup = ''
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst3/audiothing/Speakers.vst3/Contents/x86_64-linux/Speakers.so
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/clap/audiothing/Speakers.clap
    patchelf --set-rpath "${lib.strings.makeLibraryPath buildInputs}" --force-rpath $out/lib/vst/audiothing/Speakers.so
  '';

  meta = with lib; {
    description = "audiothing Speakers synth plugin";
    homepage = "https://audiothing.net/";
    platforms = platforms.x86_64;
  };
}
