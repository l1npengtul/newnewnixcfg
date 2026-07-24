{
  disko.devices = {
    disk = {
      cyberia = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S736NL0X800114N";
        content = {
          type = "gpt";
          partitions = {
            lain = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            alice = {
              size = "1860G";
              content = {
                type = "zfs";
                pool = "wired";
              };
            };
          };
        };
      };
      tachibani = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST4000NE001-2MA101_WS253ZKB";
        content = {
          type = "gpt";
          partitions = {
            eiri = {
              size = "100G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            yasuo = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "calculus";
              };
            };
          };
        };
      };
    };
    zpool = {
      wired = {
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
            postCreateHook = "zfs snapshot wired/forgor/root@blank";
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
              compression = "lz4";
            };
            mountpoint = "/persist";
          };
        };
      };
      calculus = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
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
          "rember/persist/home/l1npengtul/Downloads" = {
            type = "zfs_fs";
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "legacy";
              exec = "off";
            };
            mountpoint = "/persist/home/l1npengtul/Downloads";
          };
          "rember/persist/home/l1npengtul/Videos" = {
            type = "zfs_fs";
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "legacy";
              exec = "off";
            };
            mountpoint = "/persist/home/l1npengtul/Videos";
          };
          "rember/persist/home/l1npengtul/Pictures" = {
            type = "zfs_fs";
            options = {
              "com.sun:auto-snapshot" = "true";
              mountpoint = "legacy";
              exec = "off";
            };
            mountpoint = "/persist/home/l1npengtul/Pictures";
          };
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "wired/forgor/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "wired/rember/nix";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/log" = {
      device = "wired/rember/persist/var/log";
      fsType = "zfs";
    };
    "/persist" = {
      device = "wired/rember/persist";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/etc/nixos" = {
      device = "wired/rember/persist/etc/nixos";
      fsType = "zfs";
    };
    "/home/l1npengtul/Downloads" = {
      device = "calculus/rember/persist/home/l1npengtul/Downloads";
      fsType = "zfs";
    };
    "/home/l1npengtul/Videos" = {
      device = "calculus/rember/persist/home/l1npengtul/Videos";
      fsType = "zfs";
    };
    "/home/l1npengtul/Pictures" = {
      device = "calculus/rember/persist/home/l1npengtul/Pictures";
      fsType = "zfs";
    };
  };
}
