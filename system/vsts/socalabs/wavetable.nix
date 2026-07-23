{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  alsa-lib,
  copyDesktopItems,
  makeDesktopItem,
  xorg,
  freetype,
  expat,
  libGL,
  libjack2,
  curl,
  webkitgtk_6_0,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libxkbcommon,
  libdatrie,
  libepoxy,
  libsoup_3,
  lerc,
  sqlite,
  ninja,
  nix-update-script,
  # Disable VST building by default, since NixOS doesn't have a VST license
  enableVST2 ? false,
}: let
  version = "1.0.22";
in
  stdenv.mkDerivation {
    pname = "socalabs-wavetable";
    inherit version;

    src =
      (fetchFromGitHub {
        owner = "FigBug";
        repo = "Wavetable";
        tag = "${version}";
        hash = "sha256-tLL6/ZO3rgNXDZIZNxrCMqWTC7GAYf/Txr9c1o9ej7U=";
        fetchSubmodules = true;
        preFetch = ''
          # can't clone using ssh
          # https://github.com/jg-rp/python-jsonpath/pull/122
          export GIT_CONFIG_COUNT=1
          export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
          export GIT_CONFIG_VALUE_0=git@github.com:
        '';
      })
      .overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

    desktopItems = [
      (makeDesktopItem {
        type = "Application";
        name = "socalabs-wavetable";
        desktopName = "Socalabs Wavetable";
        comment = "Socalabs 2 Oscillator Wavetable Plugin (Standalone)";
        exec = "Wavetable";
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
    ];

    buildInputs = [
      alsa-lib
      xorg.libX11
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXtst
      xorg.libXdmcp
      xorg.xvfb
      libGL
      libjack2
      libsysprof-capture
      libselinux
      libsepol
      libthai
      libxkbcommon
      libdatrie
      libepoxy
      libsoup_3
      lerc
      freetype
      curl
      webkitgtk_6_0
      pcre2
      util-linux
      sqlite
      expat
    ];

    cmakeFlags = [
      (lib.cmakeBool "JUCE_COPY_PLUGIN_AFTER_BUILD" false)
      "--preset ninja-gcc"
    ];

    patchPhase = ''
      substituteInPlace CMakeLists.txt \
      --replace-fail 'FORMATS Standalone VST VST3 AU LV2' 'FORMATS Standalone ${lib.optionalString enableVST2 "VST"} VST3 LV2'

      # we need to patch JUCE itself to enable jack MIDI support
      # please https://github.com/juce-framework/JUCE/issues/952
      # TODO: remove when juce updates :D
      substituteInPlace modules/juce/modules/juce_audio_devices/native/juce_Midi_linux.cpp \
      --replace-fail "port = client.createPort (portName, forInput, false);" "port = client.createPort (portName, forInput, true);"
    '';

    cmakeBuildType = "Release";

    strictDeps = true;

    preBuild = ''
      # build takes 10 years without this set
      HOME=(mktemp -d)

      cd ../Builds/ninja-gcc
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/vst3 $out/lib/lv2 $out/bin

      ${lib.optionalString enableVST2 ''
        mkdir -p $out/lib/vst
        cp -r Wavetable_artefacts/Release/VST/libWavetable.so $out/lib/vst
      ''}

      cp -r Wavetable_artefacts/Release/LV2/Wavetable.lv2 $out/lib/lv2
      cp -r Wavetable_artefacts/Release/VST3/Wavetable.vst3 $out/lib/vst3

      install -Dm755 Wavetable_artefacts/Release/Standalone/Wavetable $out/bin

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script {};

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

    meta = {
      description = "Socalabs 2 Oscillator Flexible Wavetable Plugin";
      homepage = "https://socalabs.com/synths/wavetable/";
      mainProgram = "Wavetable";
      platforms = lib.platforms.linux;
      license = [lib.licenses.bsd3] ++ lib.optional enableVST2 lib.licenses.unfree;
      maintainers = [lib.maintainers.l1npengtul];
    };
  }
