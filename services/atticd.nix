{
  inputs,
  config,
  lib,
  ...
}:
let
  shhh = builtins.toString inputs.shhh;
  cfg = config.services.attic-nix-cache;
in
{
  options.services.attic-nix-cache = {
    enable = lib.mkEnableOption "enable attic nix cache";
    caddy = {
      enable = lib.mkEnableOption "enable attic via caddy";
      address = lib.mkOption {
        description = "address to expose on";
        types = lib.types.str;
        default = "cache.l1npengtul.lol";
      };
    };
    doPersistance = lib.mkEnableOption "enable persistance for attic";
  };

  config =
    lib.mkIf cfg.enable {
      sops.secrets.ATTICD_ENVFILE = {
        sopsFile = "${shhh}/atticd.env";
        format = "dotenv";
        owner = "atticd";
      };

      services.atticd = {
        enable = true;
        environmentFile = config.sops.secrets.ATTICD_ENVFILE.path;

        settings = {
          listen = "[::]:10080";

          jwt = { };

          chunking = {
            nar-size-threshold = 64 * 1024;
            min-size = 16 * 1024;
            avg-size = 64 * 1024;
            max-size = 256 * 1024;
          };
        };
      };
    }
    // lib.mkIf cfg.caddy.enable {
      services.caddy.virtualHosts."${cfg.caddy.address}".extraConfig = ''
        tls {
          dns cloudflare {env.CF_API_TOKEN}
        }
        reverse_proxy localhost:${10080}
      '';
    }
    // lib.mkIf cfg.doPersistance {
      environment.persistence."/persist".directories = [
        {
          directory = "/var/lib/atticd";
          user = "atticd";
          mode = "u=rw,g=rw,o=r";
        }
      ];
    };
}
