{ ... }: {
  users.groups.service-users = { };
  services = {
    dbus.implementation = "broker";
    logrotate.enable = true;
    journald = {
      upload.enable = false; # Disable remote log upload (the default)
      storage = "volatile"; # Store logs in memory
      extraConfig = ''
        SystemMaxUse=500M
        SystemMaxFileSize=50M
      '';
    };
  };
}
