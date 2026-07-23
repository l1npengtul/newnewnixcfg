{ ... }: {
  imports = [
    ./audit.nix
    ./boot.nix
    ./firewall.nix
    ./headless.nix
    ./kde.nix
    ./kernel.nix
    ./local-serial.nix
    ./nix.nix
    ./noexec.nix
    ./pengfiles.nix
    ./rember.nix
    ./remote-unlock.nix
    ./sshd.nix
    ./systemd.nix
    ./zfs-cache-limit.nix
    ./zfs-forgor.nix
    ./zfs.nix
  ];
}
