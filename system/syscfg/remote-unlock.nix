{ lib, config, ... }:
{
  options = {
    services.remote-unlock.enable = lib.mkEnableOption "enable remote SSH unlock";
  };

  config = lib.mkIf config.services.remote-unlock.enable {
    boot.initrd.systemd.network = {
      enable = true;
      wait-online.enable = false;
      networks."10-wired" = {
        matchConfig.Name = "enp*";
        networkConfig.DHCP = "yes";
      };
    };

    boot.initrd.network.ssh = {
      enable = true;
      port = 2222;
      hostKeys = [ "/persist/etc/secrets/initrd/ssh_host_ed25519_key" ];
      authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
    };
  };
}
