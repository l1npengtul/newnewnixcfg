{
  lib,
  buildPythonPackage,
  fetchPypi,
  # build-system
  setuptools,
  wheel,
  numpy,
  torch,
  torchaudio,
  tqdm,
}:
buildPythonPackage rec {
  pname = "openunmix";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zJJFznKHAPXQtyxn8BvkFid35hfNxH+bA1ljr6wYD8g=";
  };

  doCheck = false;

  pyproject = true;
  build-system = [
    setuptools
  ];

  dependencies = [
    setuptools
    wheel
    numpy
    torch
    torchaudio
    tqdm
  ];

  nativeCheckInputs = [
  ];
}
