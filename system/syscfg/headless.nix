{ lib, config, ... }: {
  options = {
    services.headless.enable = lib.mkEnableOption "make sure it is headless";
  };

  config = lib.mkIf config.services.headless.enable {
    services.xserver.enable = lib.mkForce false;
  };
}
