{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rvpacker-txt-rs";
  version = "13.0.1";

  src = fetchFromGitHub {
    owner = "RPG-Maker-Translation-Tools";
    repo = "rvpacker-txt-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1zCG0gEahiQJErFJDPC/qTp4Zp140dylr2OugN6bI00=";
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
