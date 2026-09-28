{ ... }: {
  boot.zfs.forceImportRoot = false;
  services.zfs.autoScrub.enable = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enabled = true;
}
