{
  rustPlatform,
  fetchFromGitHub,
  sqlx-cli,
}: let
  version = "0.2.9";
in
  rustPlatform.buildRustPackage {
    pname = "madamoiselle";
    inherit version;

    src = fetchFromGitHub {
      owner = "l1npengtul";
      repo = "madamoiselle";
      tag = "${version}";
      hash = "sha256-URNn7n/vC/t3TuH1TM67GWLJTQGupy+4WoVinI4uk0E=";
    };

    cargoHash = "sha256-LTxqkSauBLyBnZG5a1w0ptJRpwlaWNT0MhkmUHbbyGU=";

    nativeBuildInputs = [sqlx-cli];

    configurePhase = ''
      export DATABASE_URL=sqlite:database.sqlite
      sqlx database create
      sqlx database setup
      cargo sqlx prepare
    '';
  }
