{...}: {
  services.fwupd.enable = true;
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };
}
