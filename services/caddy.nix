{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  shhh = builtins.toString inputs.shhh;
in
{
  options = {
    services.caddy-proxy.enable = lib.mkEnableOption "enable caddy";
  };

  config = lib.mkIf config.services.caddy-proxy.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
        hash = "sha256-7DGnojZvcQBZ6LEjT0e5O9gZgsvEeHlQP9aKaJIs/Zg=";
      };
      environmentFile = config.sops.secrets."CF_API_TOKEN".path;
    };

    sops.secrets."CF_API_TOKEN" = {
      sopsFile = "${shhh}/caddy.env";
      format = "dotenv";
      owner = "caddy";
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
