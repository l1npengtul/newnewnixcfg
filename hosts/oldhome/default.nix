{
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./services.nix
  ];

  time.timeZone = "Asia/Tokyo";

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  networking.hostName = "oldhome"; # Define your hostname.
  networking.hostId = inputs.shhh.systems.oldhome.hostId;

  hardware.gpu-type.enable = true;
  hardware.gpu-type.type = "intel";

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

  hardware.battery-optimisations.enable = true;

  services.kde-desktop.enable = true;

  system.stateVersion = "26.05";
}
