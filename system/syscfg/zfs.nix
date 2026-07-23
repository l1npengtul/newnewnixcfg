{ ... }: {
  boot.zfs.forceImportRoot = false;
  services.zfs.autoScrub.enable = true;
}
