{lib, ...}: let
  trusted = ["@wheel"];
in {
  nix.settings.allowed-users = trusted;
  nix.settings.trusted-users = trusted;
}
