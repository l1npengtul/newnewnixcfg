{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.git-forgejo;
  srv = inputs.shhh;
  shhh = builtins.toString inputs.shhh;
in
{
  options = {
    services.git-forgejo = {
      enable = lib.mkEnableOption "enable forgejo";
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      database.type = "sqlite";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "git.${srv.domain}";
          ROOT_URL = "https://git.${srv.domain}/";
          HTTP_PORT = 3000;
        };
        service.DISABLE_REGISTRATION = true;
        actions = {
          ENABLED = true;
        };
        "cron.sync_external_users" = {
          RUN_AT_START = true;
          SCHEDULE = "@every 6h";
          UPDATE_EXISTING = true;
        };
        mailer = srv.services.forgejo-mailer;
      };
      secrets = {
        mailer.PASSWD = config.sops.secrets.forgejo-mailer-password.path;
      };
    };

    sops.secrets.forgejo-mailer-password = {
      sopsFile = "${shhh}/forgejo.yaml";
      owner = "forgejo";
    };
    sops.secrets.forgejo-admin-password = {
      sopsFile = "${shhh}/forgejo.yaml";
      owner = "forgejo";
    };

    services.caddy.virtualHosts."${srv.domain}".extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
      }
      reverse_proxy localhost:3000
    '';

    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/forgejo";
        user = "forgejo";
        mode = "u=rw,g=r,o=";
      }
    ];

    systemd.services.forgejo.preStart =
      let
        adminCmd = "${lib.getExe cfg.package} admin user";
        pwd = config.sops.secrets.forgejo-admin-password;
        user = "admin";
      in
      ''
        ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
      '';
  };
}
