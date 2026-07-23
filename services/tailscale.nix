{
  config,
  pkgs,
  lib,
  options,
  inputs,
  ...
}:
let
  cfg = config.services.tailscale-connect;
  shhh = builtins.toString inputs.shhh;
in
{
  options = {
    services.tailscale-connect = {
      enable = lib.mkEnableOption "enable tailscale autoconnect";
      side = lib.mkOption {
        description = "what side, a server or client?";
        type = lib.types.enum [
          "server"
          "client"
        ];
        default = "client";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      if cfg.side == "client" then
        [
          pkgs.ktailctl
          pkgs.tailscale
        ]
      else
        [ pkgs.tailscale ];

    sops.secrets."ts-auth/${config.networking.hostName}" = {
      sopsFile = "${shhh}/tailscale.yaml";
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = cfg.side;
      authKeyFile = config.sops.secrets."ts-auth/${config.networking.hostName}".path;
    };

    networking.firewall = {
      # enable the firewall
      enable = true;

      # always allow traffic from your Tailscale network
      trustedInterfaces = [ "tailscale0" ];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/tailscale";
        user = "tailscale";
        group = "tailscale";
        mode = "u=rw,g=rw,o=";
      }
    ];
  };
}
