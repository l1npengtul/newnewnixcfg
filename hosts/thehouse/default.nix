{
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./services.nix
  ];

  time.timeZone = "Asia/Tokyo";

  networking.hostName = "thehouse";
  networking.hostId = inputs.shhh.systems.thehouse.hostId;

  fileSystems."/persist".neededForBoot = true;

  boot.initrd.availableKernelModules = [ "e1000e" ];

  hardware.gpu-type = "intel";

  environment.system-profile = "server";

  system.stateVersion = "26.05";
}
