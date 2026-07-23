{
  options,
  config,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.zfs-forgor;
in
{
  options.services.zfs-forgor = {
    enable = lib.mkEnableOption "enable ZFS impermanence wipe";
    pool = lib.mkOption {
      type = lib.types.str;
      description = "ZFS pool";
    };
    dataset = lib.mkOption {
      type = lib.types.str;
      description = "ZFS subdevice to wipe";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd.services.zfs-wipe = {
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      requiredBy = [ "initrd.target" ];
      before = [ "sysroot.mount" ];
      after = [
        "zfs-import-${cfg.pool}.service"
      ];

      script = ''
        zfs rollback -r ${cfg.pool}/${cfg.dataset}@blank && echo "Rolled back ${cfg.pool}/${cfg.dataset} sucessfully."
      '';
    };
  };
}
