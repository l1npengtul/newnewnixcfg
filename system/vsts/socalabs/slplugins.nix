{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  alsa-lib,
  copyDesktopItems,
  makeDesktopItem,
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
  libX11,
  libXcomposite,
  libXcursor,
  libXinerama,
  libXrandr,
  libXtst,
  libXdmcp,
  xvfb,
  makeFontsCache,
  # Disable VST building by default, since NixOS doesn't have a VST license
  enableVST2 ? false,
}:
let
  fontConf = makeFontsCache {
    fontDirectories = [ ];
  };
in
stdenv.mkDerivation {
  pname = "socalabs-sfx8";
  version = "1.1.0";

  src =
    (fetchFromGitHub {
      owner = "FigBug";
      repo = "slPlugins";
      rev = "482e4ae488ec175e8afe6f76894f0793bbd76c7a";
      hash = "sha256-XwE5G5lWJq+qLOH+yYYZdrxD/SkpYacLa9wBaN+vhZI=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "socalabs-sfx8";
      desktopName = "Socalabs SFX8";
      comment = "Socalabs SFX8 Plugin (Standalone)";
      icon = "SFX8";
      exec = "SFX8";
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
    libX11
    libXcomposite
    libXcursor
    libXinerama
    libXrandr
    libXtst
    libXdmcp
    xvfb
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
    --replace-fail 'FORMATS Standalone VST VST3 AU LV2' 'FORMATS Standalone ${lib.optionalString enableVST2 "VST"} VST3'

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
    export HOME=(mktemp -d)
    export FONTCONFIG_FILE=${fontConf}

    cd ../Builds/ninja-gcc
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3 $out/bin

    ${lib.optionalString enableVST2 ''
      mkdir -p $out/lib/vst
      cp -r SFX8_artefacts/Release/VST/libSFX8.so $out/lib/vst
    ''}

    cp -r SFX8_artefacts/Release/VST3/SFX8.vst3 $out/lib/vst3

    install -Dm755 SFX8_artefacts/Release/Standalone/SFX8 $out/bin

    install -Dm444 $src/plugin/Resources/logo.png $out/share/pixmaps/SFX8.png

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
    description = "Socalabs SFX8 Plugin";
    homepage = "https://socalabs.com/synths/sfx8/";
    mainProgram = "SFX8";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.gpl3 ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
