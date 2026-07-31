{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./services.nix
  ];

  time.timeZone = "Asia/Tokyo";

  networking.hostName = "clubcyberia";
  networking.hostId = inputs.shhh.systems.clubcyberia.hostId;

  hardware.gpu-type.enable = true;
  hardware.gpu-type.type = "amd";

  services.rember.enable = true;

  programs.sets = {
    enable = true;
    keyboard.enable = true;
    programming.enable = true;
    diskmgmt.enable = true;
    udf.enable = true;
    appimage.enable = true;
    gaming.enable = true;
    music.enable = true;
  };

  hardware.audio-type.enable = true;
  hardware.audio-type.type = "music";

  services.kde-desktop.enable = true;

  system.stateVersion = "26.05";
}
