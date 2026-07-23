{
  lib,
  options,
  config,
  ...
}:
let
  cfg = config.system.zfs-cache-limiter;
in
{
  options.system.zfs-cache-limiter = {
    enable = lib.mkEnableOption "Enable ZFS Cache Limit";
    maxMemory = lib.mkOption {
      type = lib.types.int;
      default = 4294967296;
      description = "Max amount of RAM in bytes to allocate to ZFS Cache";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "zfs.zfs_arc_max=${builtins.toString cfg.maxMemory}"
      "zfs.zfs_arc_min=${builtins.toString (cfg.maxMemory / 2)}"
    ];
  };
}
