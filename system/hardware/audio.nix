{ lib, config, ... }:
let
  cfg = config.hardware.audio-type;
in
{
  options = {
    hardware.audio-type = {
      enable = lib.mkEnableOption "enable audio option";
      type = lib.mkOption {
        description = "what type of audio system to use";
        type = lib.types.enum [
          "none"
          "standard"
          "music"
        ];
        default = "none";
      };
    };
  };

  config =
    lib.mkIf (cfg == "standard" && cfg.enable) {
      services = {
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          jack.enable = true;
          pulse.enable = true;
          socketActivation = true;
        };
      };
    }
    // lib.mkIf (cfg == "music" && cfg.enable) {
      services = {
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          jack.enable = true;
          pulse.enable = true;
          socketActivation = true;
        };
      };

      musnix = {
        enable = true;
        rtcqs.enable = true;
        kernel.realtime = true;
        rtirq.enable = true;
        das_watchdog.enable = true;
      };
      security.rtkit.enable = true;
    };
}
