{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.pipewire-roc;
in
{
  options = {
    services.pipewire-roc = {
      enable = lib.mkEnableOption "enable remote transmission of pipewire audio via ROC";
      side = lib.mkOption {
        description = "which side, sink (sender) or source (receiver)";
        types = lib.types.enum [
          "sink"
          "source"
        ];
      };
      receiverIp = lib.mkOption {
        description = "IPs to send the thing to";
        types = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ roc-toolkit ];

    services.pipewire.configs =
      { }
      // lib.mkIf (cfg.side == "sink") {
        "roc-sink" = {
          name = "libpipewire-module-roc-sink";
          args = {
            fec.code = "rs8m";
            remote.ip = cfg.receiverIp;
            remote.source.port = 12001;
            remote.repair.port = 12002;
            sink.name = "ROC Sink";
            sink.props = {
              node.name = "roc-sink";
            };
          };
        };
      }
      // lib.mkIf (cfg.side == "source") {
        "roc-sink" = {
          name = "libpipewire-module-roc-source";
          args = {
            local.ip = "0.0.0.0";
            resampler.profile = "medium";
            fec.code = "rs8m";
            sess.latency.msec = 100;
            local.source.port = 12001;
            local.repair.port = 12002;
            source.name = "Roc Source";
            source.props = {
              node.name = "roc-source";
            };
          };
        };
      };
  };
}
