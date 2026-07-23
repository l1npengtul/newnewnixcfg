{ osConfig, ... }:

let
  per-system = ./per-system;
  path = "${per-system}/${osConfig.networking.hostName}.nix";
in
{
  imports = [
    ./services
    ./applications

    ./home.nix
    ./plasma.nix
    ./shell.nix
    ./persist.nix
    (import path)
  ];
}
