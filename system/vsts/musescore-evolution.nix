{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  libjack2,
  lame,
  libogg,
  libpulseaudio,
  libsndfile,
  libvorbis,
  portaudio,
  portmidi,
  libsForQt5,
  makeDesktopItem,
  copyDesktopItems,
  nixosTests,
}: let
  version = "3.7.0-unstable";
in
  stdenv.mkDerivation {
    inherit version;
    pname = "musescore-evolution";

    src = fetchFromGitHub {
      owner = "Jojo-Schmitz";
      repo = "MuseScore";
      rev = "1bce742e5d3f7ce3ed6fc036892bb046cbce1a68";
      hash = "sha256-t99y9wy2dlaRPrW3GBD0LrHaNqUhZgORYtc8981A1yE=";
    };

    desktopItems = [
      (makeDesktopItem {
        type = "Application";
        name = "musescore-evolution";
        desktopName = "Musescore Evolution";
        comment = "Continuous Development of the 3.x branch of MuseScore";
        exec = "musescore";
        categories = [
          "Audio"
          "AudioVideo"
        ];
      })
    ];

    patches = [
      ./remove_qtwebengine_install_hack.patch
    ];

    cmakeFlags = [
      "-DMUSESCORE_BUILD_CONFIG=release"
      "-DUSE_SYSTEM_FREETYPE=ON"
    ];

    qtWrapperArgs = [
      # MuseScore JACK backend loads libjack at runtime.
      "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libjack2]}"
      # There are some issues with using the wayland backend, see:
      # https://musescore.org/en/node/321936
      "--set-default QT_QPA_PLATFORM xcb"
    ];

    nativeBuildInputs = [cmake pkg-config libsForQt5.qt5.wrapQtAppsHook copyDesktopItems];

    buildInputs = with libsForQt5.qt5; [
      alsa-lib
      libjack2
      freetype
      lame
      libogg
      libpulseaudio
      libsndfile
      libvorbis
      portaudio
      portmidi # tesseract
      qtbase
      qtdeclarative
      qtgraphicaleffects
      qtquickcontrols2
      qtscript
      qtsvg
      qttools
      qtwebengine
      qtxmlpatterns
    ];

    passthru.tests = nixosTests.musescore;

    meta = with lib; {
      description = "Continuous Development of the 3.x branch of MuseScore";
      homepage = "https://github.com/Jojo-Schmitz/MuseScore";
      license = licenses.gpl2;
      maintainers = with maintainers; [l1npengtul];
      platforms = platforms.linux;
    };
  }
