{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  alsa-lib,
  copyDesktopItems,
  makeDesktopItem,
  libX11,
  libXcomposite,
  libXcursor,
  libXinerama,
  libXrandr,
  libXtst,
  libXdmcp,
  libXext,
  xvfb,
  freetype,
  fontconfig,
  expat,
  libGL,
  libjack2,
  curl,
  ninja,
  writableTmpDirAsHomeHook,
  nix-update-script,
  setbfree,
  # Disable VST building by default, since NixOS doesn't have a VST license
  enableVST2 ? false,
}: let
  version = "1.0.1";
in
  stdenv.mkDerivation {
    pname = "socalabs-organ";
    inherit version;

    src = fetchFromGitHub {
      owner = "FigBug";
      repo = "Organ";
      rev = "v${version}";
      hash = "sha256-gpC1+TfzLojJuE24aQUrOl3HIzC7x3CMrB4h7GWfZv0=";
      fetchSubmodules = true;
      preFetch = ''
        # can't clone using ssh
        export GIT_CONFIG_COUNT=1
        export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
        export GIT_CONFIG_VALUE_0=git@github.com:
      '';
    };

    desktopItems = [
      (makeDesktopItem {
        type = "Application";
        name = "socalabs-organ";
        desktopName = "Socalabs Organ";
        comment = "Socalabs Organ Plugin based on setBFree (Standalone)";
        exec = "Organ";
        categories = [
          "Audio"
          "AudioVideo"
        ];
      })
    ];

    nativeBuildInputs = [
      cmake
      pkg-config
      copyDesktopItems
      ninja
      writableTmpDirAsHomeHook
    ];

    buildInputs = [
      alsa-lib
      libX11
      libXcomposite
      libXcursor
      libXinerama
      libXrandr
      libXtst
      libXdmcp
      libXext
      xvfb
      libGL
      libjack2
      freetype
      fontconfig
      expat
      curl
    ];

    cmakeFlags = [
      (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
      (lib.cmakeBool "BUILD_EXTRAS" true)
      "--preset ninja-gcc"
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt \
      --replace-fail 'FORMATS Standalone VST VST3 AU LV2' 'FORMATS Standalone ${lib.optionalString enableVST2 "VST"} VST3 LV2'

      # we need to patch JUCE itself to enable jack MIDI support
      # please https://github.com/juce-framework/JUCE/issues/952
      # TODO: remove when juce updates :D
      substituteInPlace modules/juce/modules/juce_audio_devices/native/juce_Midi_linux.cpp \
      --replace-fail "port = client.createPort (portName, forInput, false);" "port = client.createPort (portName, forInput, true);"

      # fix compile error
      sed -i '32i #include <strings.h>' plugin/setBfree/src/tonegen.c

      # update the vendored version of setBFree in this package
      #rm -r plugin/setBfree
      #ln -s ${setbfree.src} plugin/setBfree
    '';

    strictDeps = true;

    preBuild = ''
      cd ../Builds/ninja-gcc
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/vst3 $out/lib/lv2 $out/bin

      ${lib.optionalString enableVST2 ''
        mkdir -p $out/lib/vst
        cp -r Organ_artefacts/Release/VST/libOrgan.so $out/lib/vst
      ''}

      cp -r Organ_artefacts/Release/LV2/Organ.lv2 $out/lib/lv2
      cp -r Organ_artefacts/Release/VST3/Organ.vst3 $out/lib/vst3

      install -Dm755 Organ_artefacts/Release/Standalone/Organ $out/bin

      runHook postInstall
    '';

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

    passthru.updateScript = nix-update-script {};

    meta = {
      description = "Socalabs Organ Plugin based on setBFree";
      homepage = "https://socalabs.com/synths/organ/";
      mainProgram = "Organ";
      platforms = lib.platforms.linux;
      license = [lib.licenses.gpl3Only] ++ lib.optional enableVST2 lib.licenses.unfree;
      maintainers = [lib.maintainers.l1npengtul];
    };
  }
