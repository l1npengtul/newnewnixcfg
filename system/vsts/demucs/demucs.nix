{
  lib,
  python3Packages,
  fetchFromGitHub,
  dora-search,
  lameenc,
  openunmix,
}:
python3Packages.buildPythonApplication rec {
  pname = "demucs";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "adefossez";
    repo = "demucs";
    rev = "b9ab48cad45976ba42b2ff17b229c071f0df9390";
    hash = "sha256-FkN7wIiO6xSYoAQBQHdxY92fV+1q3dvUPQu//oqhRhc=";
  };

  # do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  build-system = with python3Packages; [
    setuptools
  ];
  pyproject = true;

  dependencies = with python3Packages; [
    dora-search
    einops
    julius
    lameenc
    openunmix
    pyyaml
    torch
    torchaudio
    tqdm
  ];
}
