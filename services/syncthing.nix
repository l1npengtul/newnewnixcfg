{
  inputs,
  config,
  lib,
  ...
}:
let
  shhh = builtins.toString inputs.shhh;
  syc = inputs.shhh.services.syncthing;
  cfg = config.services.syncthing-thing;
  username = cfg.username;
  pathPrefix =
    if (cfg.systemOrHome == "home") then "/home/${username}" else "/var/lib/syncthing/sync_folders";

  cfgdir =
    if (cfg.systemOrHome == "home") then
      "/home/${username}/.local/state/syncthing"
    else
      "/var/lib/syncthing";
in
{
  options = {
    services.syncthing-thing = {
      enable = lib.mkEnableOption "enable syncthing";
      username = lib.mkOption {
        description = "user to run syncthing as";
        default = "syncthing";
        type = lib.types.str;
      };
      systemOrHome = lib.mkOption {
        description = "home or system";
        default = "home";
        type = lib.types.enum [
          "home"
          "system"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      overrideDevices = true;
      overrideFolders = true;
      key = config.sops.secrets."syncthing-key".path;
      cert = config.sops.secrets."syncthing-cert".path;
      guiAddress = "127.0.0.1:8384";
      guiPasswordFile = config.sops.secrets."syncthing/password".path;

      user = cfg.username;

      dataDir = cfgdir;

      settings = {
        devices = syc.devices;
        folders = {
          "Documents" = {
            path = pathPrefix + "/Documents";
            devices = [
              "thehouse"
              "clubcyberia"
              "oldhome"
              "pegrose512"
            ];
          };
          "Pictures" = {
            path = pathPrefix + "/Pictures";
            devices = [
              "thehouse"
              "clubcyberia"
              "oldhome"
              "pegrose512"
            ];
          };
          "Music" = {
            path = pathPrefix + "/Music";
            devices = [
              "thehouse"
              "clubcyberia"
              "oldhome"
              "pegrose512"
              "mouthwashing"
            ];
          };
          ".wine" = {
            path = pathPrefix + "/.wine";
            devices = [
              "thehouse"
              "clubcyberia"
              "oldhome"
              "pegrose512"
            ];
          };
          "supernote" = {
            path = pathPrefix + "/supernote";
            devices = [
              "thehouse"
              "clubcyberia"
              "oldhome"
              "pegrose512"
              "supernote-a5x"
            ];
          };
        };
        gui = {
          user = username;
        };
      };
    };

    sops.secrets."syncthing-key" = {
      sopsFile = "${shhh}/syncthing-keys/${config.networking.hostName}/key.pem";
      format = "binary";
      owner = username;
    };
    sops.secrets."syncthing-cert" = {
      sopsFile = "${shhh}/syncthing-keys/${config.networking.hostName}/cert.pem";
      format = "binary";
      owner = username;
    };
    sops.secrets."syncthing/password" = {
      sopsFile = "${shhh}/syncthing.yaml";
      owner = username;
    };
    sops.secrets."syncthing/decrypt" = {
      sopsFile = "${shhh}/syncthing.yaml";
      owner = username;
    };

    environment.persistence."/persist" = lib.mkIf (cfg.systemOrHome == "system") {
      directories = [
        {
          directory = "/var/lib/syncthing";
          user = cfg.username;
          group = "syncthing";
          mode = "u=rw,g=rw,o=r";
        }
      ];
    };
  };
}
