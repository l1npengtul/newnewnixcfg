{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.yasl-bot;
  shhh = builtins.toString inputs.shhh;
in
{
  options = {
    services.yasl-bot = {
      enable = lib.mkEnableOption "enable yasl";
    };
  };

  config = lib.mkIf cfg.enable {
    services.yasl = {
      enable = true;
      settings = {
        token_file = config.sops.secrets."yasl-discord-token".path;
        log_channel_webhook_file = config.sops.secrets."yasl-discord-webhook".path;
        mod_role = 1449719505701044246;
        main_server = 1449712906898771970;
        qurantine_add_role = 1500965429466632334;
        qurantine_prevent_role = 1449750402345078844;
      };
    };

    sops.secrets."yasl-discord-token" = {
      sopsFile = "${shhh}/yasl.yaml";
      restartUnits = [ "yasl.service" ];
      owner = "yasl";
    };
    sops.secrets."yasl-discord-webhook" = {
      sopsFile = "${shhh}/yasl.yaml";
      restartUnits = [ "yasl.service" ];
      owner = "yasl";
    };
    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/yasl";
        user = "yasl";
        group = "yasl";
        mode = "u=rw,g=r,o=";
      }
    ];
  };
}
