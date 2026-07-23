{
  disko.devices = {
    disk = {
      haibane = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S649NL0W150189F";
        content = {
          type = "gpt";
          partitions = {
            reki = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            rakka = {
              size = "895G";
              content = {
                type = "zfs";
                pool = "abandonedfactory";
              };
            };
            toga = {
              size = "33G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
          };
        };
      };
    };
    zpool = {
      abandonedfactory = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          relatime = "off";
          acltype = "posixacl";
          dnodesize = "auto";
          recordsize = "1M";
          devices = "off";
          exec = "off";
          canmount = "off";
          mountpoint = "none";
          normalization = "formD";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
        };
        options = {
          ashift = "13";
          autotrim = "on";
        };

        datasets = {
          "forgor" = {
            type = "zfs_fs";
            options = {
              canmount = "noauto";
              mountpoint = "legacy";
            };
          };
          "forgor/root" = {
            type = "zfs_fs";
            options = {
              "com.sun:auto-snapshot" = "false";
              mountpoint = "legacy";
              exec = "off";
            };
            mountpoint = "/";
            postCreateHook = "zfs snapshot abandonedfactory/forgor/root@blank";
          };
          "rember" = {
            type = "zfs_fs";
            options = {
              canmount = "noauto";
              mountpoint = "legacy";
            };
          };
          "rember/nix" = {
            type = "zfs_fs";
            options = {
              "com.sun:auto-snapshot" = "false";
              mountpoint = "legacy";
              exec = "on";
              compression = "zstd";
            };
            mountpoint = "/nix";
          };
          "rember/persist/var/log" = {
            type = "zfs_fs";
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "legacy";
              exec = "off";
              compression = "zstd";
            };
            mountpoint = "/var/log";
          };
          "rember/persist/etc/nixos" = {
            type = "zfs_fs";
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "legacy";
              exec = "off";
              compression = "zstd";
            };
            mountpoint = "/etc/nixos";
          };
          "rember/persist" = {
            type = "zfs_fs";
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "legacy";
              exec = "off";
              compression = "zstd";
            };
            mountpoint = "/persist";
          };
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "abandonedfactory/forgor/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "abandonedfactory/rember/nix";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/log" = {
      device = "abandonedfactory/rember/persist/var/log";
      fsType = "zfs";
    };
    "/persist" = {
      device = "abandonedfactory/rember/persist";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/etc/nixos" = {
      device = "abandonedfactory/rember/persist/etc/nixos";
      fsType = "zfs";
    };
  };
}
