{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    hardware.printer-module.enable = lib.mkEnableOption "enable printer";
  };

  config = lib.mkIf config.hardware.printer-module.enable {

    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      samsung-unified-linux-driver
      splix
      gutenprint
      gutenprintBin
    ];
  };
}
