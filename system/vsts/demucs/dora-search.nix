{
  lib,
  python3Packages,
  fetchFromGitHub,
  treetable,
  submitit,
}:
python3Packages.buildPythonPackage rec {
  pname = "dora-search";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "dora";
    tag = "v0.1.12";
    hash = "sha256-v18FgiBdlNSGQmCnq63wCxcO8kJCPsUt0VznUlSPyoM=";
  };

  doCheck = false;

  pyproject = true;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = with python3Packages; [
    setuptools
    setuptools-scm
    matplotlib
    pandas
    numpy
    scipy
    scikit-learn
    treetable
    submitit
    torch
    retrying
    omegaconf
  ];

  nativeCheckInputs = [
  ];
}
