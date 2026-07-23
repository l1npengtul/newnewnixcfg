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
  # Disable VST building by default, since NixOS doesn't have a VST license
  enableVST2 ? false,
}:
stdenv.mkDerivation {
  pname = "socalabs-piano";
  version = "1.0.0";

  src =
    (fetchFromGitHub {
      owner = "FigBug";
      repo = "Piano";
      rev = "3a5229a78a8441f9331c267cc5a9ae22f0cae016";
      hash = "sha256-8ZmpiQwKzirJ8WKDSNCANuanvL3jazdulEM/tcJ+k4E=";
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
      name = "socalabs-piano";
      desktopName = "Socalabs Piano";
      comment = "Socalabs Physical Modeling Piano Plugin (Standalone)";
      exec = "Piano";
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
      cp -r Piano_artefacts/Release/VST/libPiano.so $out/lib/vst
    ''}

    cp -r Piano_artefacts/Release/LV2/Piano.lv2 $out/lib/lv2
    cp -r Piano_artefacts/Release/VST3/Piano.vst3 $out/lib/vst3

    install -Dm755 Piano_artefacts/Release/Standalone/Piano $out/bin

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

  meta = {
    description = "Socalabs Physical Modeling Piano Plugin";
    homepage = "https://socalabs.com/synths/piano/";
    mainProgram = "Piano";
    platforms = lib.platforms.linux;
    license = [lib.licenses.gpl3Only] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [lib.maintainers.l1npengtul];
  };
}
