{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    services.antivirus.enable = lib.mkEnableOption "enable clamav";
  };

  config = lib.mkIf config.services.antivirus.enable {

    environment.systemPackages = with pkgs; [ clamav ];

    services.clamav = {
      daemon.enable = true;
      updater = {
        enable = true;
        interval = "weekly";
        frequency = 1;
      };
    };
  };
}
