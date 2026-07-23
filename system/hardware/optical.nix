{ lib, config, ... }:
{
  options = {
    hardware.optical-drive.enable = lib.mkEnableOption "enable optical drive";
  };

  config = lib.mkIf config.hardware.optical-drive.enable {
    boot.kernelModules = [ "sg" ];
  };
}
