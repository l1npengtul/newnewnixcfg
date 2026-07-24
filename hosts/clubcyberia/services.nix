{ ... }: {
  services = {
    tailscale-connect = {
      enable = true;
      side = "client";
    };

    zfs-forgor = {
      enable = true;
      pool = "wired";
      dataset = "forgor/root";
    };

    syncthing-thing = {
      enable = true;
      systemOrHome = "home";
      username = "l1npengtul";
    };
  };
  system.zfs-cache-limiter = {
    enable = true;
    maxMemory = 4294967296;
  };
}
