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

  hardware.gpu-type.enable = true;
  hardware.gpu-type.type = "intel";

  services.rember.enable = true;

  hardware.audio-type.enable = false;

  services.kde-desktop.enable = true;

  system.stateVersion = "26.05";
}
