{
  disko.zfs.enable = true;
  disko.devices = {
    disk = {
      gestalt = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_1TB_S5H9NS1NB19519W";
        content = {
          type = "gpt";
          partitions = {
            alina = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            ariane = {
              size = "895G";
              content = {
                type = "zfs";
                pool = "sierpinski-s23";
              };
            };
            isa = {
              size = "31G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
          };
        };
      };
      replika = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_1TB_S5H9NS1NB19521J";
        content = {
          type = "gpt";
          partitions = {
            lstr512 = {
              size = "895G";
              content = {
                type = "zfs";
                pool = "sierpinski-s23";
              };
            };
            fklr = {
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
      sierpinski-s23 = {
        type = "zpool";
        mode = "mirror";
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
            postCreateHook = "zfs snapshot sierpinski-s23/forgor/root@blank";
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
              exec = "on";
              compression = "lz4";
            };
            mountpoint = "/persist";
          };
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "sierpinski-s23/forgor/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "sierpinski-s23/rember/nix";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/log" = {
      device = "sierpinski-s23/rember/persist/var/log";
      fsType = "zfs";
    };
    "/persist" = {
      device = "sierpinski-s23/rember/persist";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
