{ ... }: {
  services = {
    tailscale-connect = {
      enable = true;
      side = "client";
    };

    zfs-forgor = {
      enable = true;
      pool = "sierpinski-s23";
      dataset = "forgor/root";
    };

    syncthing-thing = {
      enable = true;
      systemOrHome = "home";
      username = "l1npengtul";
    };
    supernote-watcher = {
      enable = true;
      user = "l1npengtul";
    };
    flatpak.enable = true;
  };
  system.zfs-cache-limiter = {
    enable = true;
    maxMemory = 12884900000;
  };
}
