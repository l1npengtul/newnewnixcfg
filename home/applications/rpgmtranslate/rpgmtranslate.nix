{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  copyDesktopItems,
  makeDesktopItem,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,}:rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rpgmtranslate";
  version = "7.0.0";

  src = fetchFromGitHub{
    owner = "RPG-Maker-Translation-Tools";
    repo = "rpgmtranslate";
    rev = "v${finalAttrs.version}";
    hash= "sha256-ljHiVeasxJ8NDjENdFN06GDnCzA9cHcESkI3ljaX5QM=";
};

postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
    cp ${./package-lock.json} package-lock.json
  '';


  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "rpgmtranslate";
      desktopName = "RPGMTranslate";
      comment = "RPG Maker Translation Tools";
      exec = "rpgmtranslate";
      icon = "rpgmtranslate";
      categories = [
        "Development"
        "Game"
      ];
    })
  ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking # Most Tauri apps need networking
    openssl
    webkitgtk_4_1
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    install -Dm444 $src/src/assets/icon.png $out/share/icons/hicolor/256x256/apps/rpgmtranslate.png
  '';

  cargoRoot = "src-tauri";
})
