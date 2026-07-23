{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.madamoiselle;
  madamoiselle = pkgs.callPackage ./madamoiselle.nix { };
  shhh = builtins.toString inputs.shhh;
in
{
  options = {
    services.madamoiselle = {
      enable = lib.mkEnableOption "enable madamoiselle";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.madamoiselle = {
      description = "madamoiselle service user";
      isSystemUser = true;
      group = "madamoiselle";
    };
    users.groups.madamoiselle = { };
    systemd.services.madamoiselle = {
      wantedBy = [ "default.target" ];
      after = [ "network.target" ];
      description = "enable madamoiselle discord bot";
      serviceConfig = {
        User = "madamoiselle";
        Group = "madamoiselle";
        Restart = "on-failure";
        NoNewPrivileges = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;

        After = [ "sops-nix.service" ];
      };

      environment = {
        RUST_LOG = "madamoiselle";
        MADAMOISELLE_DISCORD_TOKEN = config.sops.secrets."madamoiselle-discord-token".path;
      };

      script = ''
        ${madamoiselle}/bin/madamoiselle
      '';
    };

    sops.secrets."madamoiselle-discord-token" = {
      sopsFile = "${shhh}/madamoiselle.yaml";
      restartUnits = [ "madamoiselle.service" ];
      owner = "madamoiselle";
    };
    environment.systemPackages = [ madamoiselle ];
    environment.etc."madamoiselle.toml".source = ./madamoiselle.toml;
    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/madamoiselle";
        user = "madamoiselle";
        group = "madamoiselle";
        mode = "u=rwx,g=rwx,o=rw";
      }
    ];
  };
}
