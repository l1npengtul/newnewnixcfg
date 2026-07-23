{
  stdenv,
  fetchzip,
  lib,
  alsaLib,
  freetype,
  curl,
  libGL,
  libgcc,
  jack2,
  pulseaudio,
  makeWrapper,
  autoPatchelfHook,
  makeDesktopItem,
}: let
  libPath = lib.makeLibraryPath [
    alsaLib
    freetype
    curl
    libGL
    libgcc
    pulseaudio
    jack2
    stdenv.cc.cc.lib
  ];
  desktopItem = makeDesktopItem {
    name = "Synthesizer V Studio Pro (Beta)";
    desktopName = "Synthesizer V Studio Pro";
    genericName = "Vocal Synthesizer";
    comment = "Synthesizer V Vocal Synthesizer";
    terminal = false;
    type = "Application";
    categories = ["Audio" "Music"];
    keywords = ["synth" "synthv" "vocaloid" "vocal" "synthesier" "v"];
    exec = "synthv-studio";
  };
in
  stdenv.mkDerivation rec {
    pname = "synth-v-studio-pro-beta";
    version = "1.11.2b2-1";

    src = fetchzip {
      url = "https://resource.dreamtonics.com/download/English/Synthesizer%20V%20Studio%20Beta%20Version/1.11.2b2/svstudio-pro-linux64.zip";
      sha256 = "1il9gmbsg4zvbjkqi6cry4ldzpxkkgrffgz1lj07hx3l6s07igmk";
    };

    buildInputs = [alsaLib freetype curl libGL libgcc pulseaudio jack2 stdenv.cc.cc.lib makeWrapper];

    nativeBuildInputs = [autoPatchelfHook];

    installPhase = ''

      runHook preInstall

      mkdir -p $out/opt/SynthesizerVStudioPro
      mv * $out/opt/SynthesizerVStudioPro

      mkdir -p $out/bin
      #mv $out/opt/SynthesizerVStudioPro/synthv-studio $out/opt/SynthesizerVStudioPro/synthv-studio.wrapped

      #echo $(< ${stdenv.cc}/nix-support/dynamic-linker) $out/opt/SynthesizerVStudioPro/synthv-studio.wrapped \"\$@\" > $out/opt/SynthesizerVStudioPro/synthv-studio

      wrapProgram $out/opt/SynthesizerVStudioPro/synthv-studio --set LD_LIBRARY_PATH ${libPath} --set LD_PRELOAD ${stdenv.cc}/nix-support/dynamic-linker

      #chmod +x $out/opt/SynthesizerVStudioPro/synthv-studio.wrapped
      chmod +x $out/opt/SynthesizerVStudioPro/synthv-studio

      ln -s $out/opt/SynthesizerVStudioPro/synthv-studio $out/bin/synthv-studio

      mkdir -p $out/share/applications/
      ln -s ${desktopItem}/share/applications/* $out/share/applications

      runHook postInstall

    '';

    meta = with lib; {
      license = licenses.unfree;
      description = "Synthesizer V Studio Pro";
      homepage = "https://dreamtonics.com/synthesizerv/";
      platforms = ["x86_64-linux"];
    };
  }
