{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rpgm-archive-decrypter";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "RPG-Maker-Translation-Tools";
    repo = "rpgm-archive-decrypter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2nKlgoc0fqcWMbRae/WPT3JlpCvM/eQvnR0GCkNpLuM=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  buildInputs = [ ];

  nativeBuildInputs = [ ];

  env.RUSTFLAGS = "-C target-feature=+aes,+sse2";
})
