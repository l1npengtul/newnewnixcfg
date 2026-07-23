{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  time.timeZone = "Asia/Tokyo";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 48 * 1024;
    }
  ];

  fileSystems."/home/l1npengtul/hdd_files" = {
    options = [ "rw" ];
  };
  networking.hostName = "clubcyberia";
  networking.hostId = inputs.shhh.systems.clubcyberia.id;

  system.stateVersion = "24.11";
}
