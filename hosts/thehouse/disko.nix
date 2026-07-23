{
  disko.devices = {
    disk = {
      wiltshire = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Micron_2450_MTFDKBA512TFK_214532CE471F";
        content = {
          type = "gpt";
          partitions = {
            CHARLOTTE = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            Q84 = {
              size = "470G";
              content = {
                type = "zfs";
                pool = "school";
              };
            };
          };
        };
      };
      eyler = {
        type = "disk";
        device = "/dev/disk/by-id/ata-HGST_HTS721010A9E630_JR10006P1JEV4F";
        content = {
          type = "gpt";
          partitions = {
            vincent = {
              size = "895G";
              content = {
                type = "zfs";
                pool = "persistpool";
              };
            };
            scarlett = {
              size = "32G";
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
      school = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          relatime = "off";
          acltype = "posixacl";
          dnodesize = "auto";
          recordsize = "128K";
          devices = "off";
          exec = "off";
          canmount = "off";
          mountpoint = "none";
          normalization = "formD";
        };
        options = {
          ashift = "12";
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
            postCreateHook = "zfs snapshot school/forgor/root@blank";
          };
          "rember" = {
            type = "zfs_fs";
            options = {
              canmount = "noauto";
              mountpoint = "legacy";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
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
        };
      };
      persistpool = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          relatime = "off";
          acltype = "posixacl";
          dnodesize = "auto";
          recordsize = "128K";
          devices = "off";
          exec = "off";
          canmount = "off";
          mountpoint = "none";
          normalization = "formD";
        };
        options = {
          ashift = "12";
        };

        datasets = {
          "rember" = {
            type = "zfs_fs";
            options = {
              canmount = "noauto";
              mountpoint = "legacy";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
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
      device = "school/forgor/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "school/rember/nix";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/etc/nixos" = {
      device = "persistpool/rember/persist/etc/nixos";
      fsType = "zfs";
    };
    "/var/log" = {
      device = "persistpool/rember/persist/var/log";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/persist" = {
      device = "persistpool/rember/persist";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
