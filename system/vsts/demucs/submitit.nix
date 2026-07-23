{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonPackage rec {
  pname = "submitit";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "submitit";
    tag = "1.5.3";
    hash = "sha256-uBlKbg1oKeUPcWzM9WxisGtpBu69eZyTetaANYpTG5E=";
  };

  doCheck = false;
  pyproject = true;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
    wheel
    flit-core
  ];

  dependencies = with python3Packages; [
    setuptools
    setuptools-scm
    cloudpickle
    typing-extensions
  ];

  nativeCheckInputs = [
  ];
}
