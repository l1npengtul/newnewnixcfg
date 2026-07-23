{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.scanner-module.enable = lib.mkEnableOption "enable scanner";
  };

  config = lib.mkIf config.hardware.scanner-module.enable {
    hardware.sane = {
      enable = true;
      extraBackends = with pkgs; [
        sane-airscan
        epkowa
      ];
    };
    services.udev.packages = with pkgs; [
      sane-airscan
      epkowa
    ];
    environment.systemPackages = with pkgs; [
      xsane
      kdePackages.skanpage
      kdePackages.skanlite
    ];
  };
}
