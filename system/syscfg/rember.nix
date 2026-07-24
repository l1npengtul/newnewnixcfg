{ lib, config, ... }: {
  options = {
    services.rember.enable = lib.mkEnableOption "remember basic stuff";
  };

  config = lib.mkIf config.services.rember.enable {
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/log"
        "/var/lib/systemd/coredump"
        "/var/lib/nixos"
        "/var/lib/flatpak"
      ];

      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/secrets/initrd/ssh_host_ed25519_key.pub"
        "/etc/secrets/initrd/ssh_host_ed25519_key"
      ];
    };

    systemd.services.nix-daemon = {
      environment = {
        # Location for temporary files
        TMPDIR = "/var/cache/nix";
      };
      serviceConfig = {
        # Create /var/cache/nix automatically on Nix Daemon start
        CacheDirectory = "nix";
      };
    };
  };
}
