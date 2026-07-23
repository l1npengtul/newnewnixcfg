{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  buildGradlePackage,
  pkgs,
  fetchUrl,
}:
buildGradlePackage rec {
  pname = "recstar";
  version = "1.1.2";
  src = fetchFromGitHub {
    owner = "sdercolin";
    repo = "recstar";
    rev = "9f966c51f09e8bcd7bae722fbb3744fb71ea6baf";
    hash = "sha256-Sm/N1gbd8fpgPgEMK8fcbdizhTcarNxYsz8DZLuoVjo=";
  };

  preBuild = ''
    echo "buildkonfig.flavor=release" >> gradle.properties
    echo "skipAndroid=true" >> gradle.properties
  '';

  gradleBuildFlags = [
    ":desktopApp:createReleaseDistributable"
  ];

  buildInputs = [pkgs.libGL stdenv.cc.cc.lib pkgs.kotlin pkgs.makeWrapper];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  # random dependencies that decided to stop existing
  overrides = {
    "com.christophsturm.filepeek:filepeek:0.1.2" = {
      "filepeek-0.1.2.jar" = fetchUrl {
        url = "https://repo.maven.apache.org/maven2/com/christophsturm/filepeek/0.1.3/filepeek-0.1.3.jar";
        hash = "";
      };
      "filepeek-0.1.2.pom" = fetchUrl {
        url = "https://repo.maven.apache.org/maven2/com/christophsturm/filepeek/0.1.3/filepeek-0.1.3.pom";
        hash = "";
      };
    };
  };

  installPhase = ''
    makeWrapper desktopApp/build/compose/binaries/main/app/RecStar/bin/RecStar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [pkgs.libGL]}"

    mkdir -p $out/opt/recstar/lib
    mkdir -p $out/opt/recstar/bin
    mv $src/desktopApp/build/compose/binaries/main/app/RecStar/bin $out/opt/recstar/bin
    mv $src/desktopApp/build/compose/binaries/main/app/RecStar/lib $out/opt/recstar/lib

    ln -s $out/opt/recstar/bin/* $out/bin
  '';

  meta = with lib; {
    description = "UTAU Reclist recorder";
    license = licenses.asl20;
    mainProgram = "RecStar";
  };
}
