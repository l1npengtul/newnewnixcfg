{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liquidsfz";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "swesterfeld";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [ autoconf ];
})
