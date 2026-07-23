{ ... }: {
  imports = [
    ./syncthing.nix
    ./tailscale.nix

    ./madamoiselle
    ./atticd.nix
    ./caddy.nix
    ./forgejo.nix
    ./motd.nix
    ./backup.nix
    ./antivirus.nix
    ./syncthing.nix
    ./tailscale.nix
  ];
}
