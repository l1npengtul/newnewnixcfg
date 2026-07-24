{ ... }: {
  services = {
    tailscale-connect = {
      enable = true;
      side = "server";
    };

    zfs-forgor = {
      enable = true;
      pool = "school";
      dataset = "forgor/root";
    };

    syncthing-thing = {
      enable = true;
      systemOrHome = "system";
    };

    #madamoiselle.enable = true;

    audit-auditd.enable = true;
    headless.enable = true;
    local-serial.enable = true;
  };
  system.zfs-cache-limiter = {
    enable = true;
    maxMemory = 4294967296;
  };
}
