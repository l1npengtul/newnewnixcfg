{
  lib,
  stdenvNoCC,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  libarchive,
  magic-enum,
  nuspell,
  ffmpeg,
  libgit2,
  languagetool,
  openssl,
  rustPlatform,
  cargo,
  rustc,
  corrosion,
  rust-cbindgen,
  makeDesktopItem,
  copyDesktopItems,
  writeShellScript,
}:
let
  rpgmtranslate-qt-unwrapped = clangStdenv.mkDerivation (finalAttrs: {
    pname = "rpgmtranslate-qt-unwrapped";
    version = "1.0.0-rc.6";

    src = fetchFromGitHub {
      owner = "RPG-Maker-Translation-Tools";
      repo = "rpgmtranslate-qt";
      tag = "v${finalAttrs.version}";
      hash = "sha256-BELD3RpMF+S0PZZUjgf/s1gunQN0ez1eLnA3UQdNsZs=";
    };

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = ./Cargo.lock;
    };

    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';

    patches = [
      ./use-local-corrosion.patch
    ];

    buildInputs = [
      libarchive
      magic-enum
      qt6.qtbase
      qt6.qtwayland
      qt6.qtsvg
      qt6.qtmultimedia
      qt6.qttranslations
      qt6.qtdeclarative
      qt6.qttools
      nuspell
      ffmpeg
      languagetool
      openssl
      libgit2
    ];

    nativeBuildInputs = [
      cmake
      pkg-config
      qt6.wrapQtAppsHook
      qt6.qttools
      rustPlatform.cargoSetupHook
      rustPlatform.bindgenHook
      cargo
      rustc
      corrosion
      rust-cbindgen
    ];

    env.RUSTFLAGS = "-C target-feature=+aes,+sse2";

    cmakeFlags = [
      (lib.cmakeBool "ENABLE_LIBGIT2" false)
    ];
  });
in
stdenvNoCC.mkDerivation {
  pname = "rpgmtranslate-qt";
  inherit (rpgmtranslate-qt-unwrapped) version;

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "rpgmtranslate-qt";
      desktopName = "RPGMTranslate QT";
      comment = "RPG Maker Game Translation Tool";
      exec = "rpgmtranslate-qt";
      categories = [
        "Game"
        "Utility"
      ];
    })
  ];

  dontUnpack = true;
  dontConfigure = true;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  postInstall =
    let
      wrapper = writeShellScript "rpgmtranslate-qt" ''
        set -e

        mkdir -p $HOME/.local/share/rpg-maker-translation-tools/rpgmtranslate

        ${rpgmtranslate-qt-unwrapped}/bin/rpgmtranslate
      '';
    in
    ''
      mkdir -p $out/bin
      cp ${wrapper} $out/bin/rpgmtranslate-qt
    '';

}
