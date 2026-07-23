{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  time.timeZone = "Asia/Seoul";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "pegrose512";
  networking.hostId = inputs.shhh.systems.pengrose512.id;

  system.stateVersion = "24.11";
}
