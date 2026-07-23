{pkgs, ...}: let
  bubbles = pkgs.callPackage ./bubbles.nix {};
  minibit = pkgs.callPackage ./minibit.nix {};
  moonecho = pkgs.callPackage ./moonecho.nix {};
  textures = pkgs.callPackage ./textures.nix {};
  lines = pkgs.callPackage ./lines.nix {};
  noises = pkgs.callPackage ./noises.nix {};
  speakers = pkgs.callPackage ./speakers.nix {};
  fog = pkgs.callPackage ./fog.nix {};
in {
  environment.systemPackages = [
    bubbles
    minibit
    moonecho
    textures
    lines
    noises
    speakers
    fog
  ];
}
