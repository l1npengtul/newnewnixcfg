{
  inputs,
  pkgs,
  lib,
  options,
  config,
  ...
}:
let
  motdscript = pkgs.writeShellScript "message-of-the-day" ''
    USER=$(${pkgs.coreutils}/bin/whoami)
    HOST=$(${pkgs.coreutils}/bin/cat /etc/hostname)
    GENERATION=$(${pkgs.coreutils}/bin/readlink /nix/var/nix/profiles/system | ${pkgs.coreutils}/bin/cut -d- -f2)
    source /etc/os-release

    echo Welcome $USER to Titans Valor [ANO] Titans Brilliance Infrastructure.
    echo You are logged in to: $HOST
    echo Running $PRETTY_NAME, generation $GENERATION
    echo "<::>< <- le fishe"


    echo -------------
    echo ZPOOL STATUS:
    ZSTATUS=$(${pkgs.zfs}/bin/zpool status -v)
    ${pkgs.zfs}/bin/zpool status -v

    echo -------------
    echo Needs Reboot Status:
    ${
      inputs.nixos-needsreboot.packages.${pkgs.stdenv.hostPlatform.system}.default
    }/bin/nixos-needsreboot --dry-run
    echo -------------
  '';
  cfg = config.services.use-motd;
in
{
  environment.systemPackages = [
    inputs.nixos-needsreboot.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.rust-motd
  ];

  programs.rust-motd = {
    enable = true;
    enableMotdInSSHD = true;
    settings = {
      global.version = "1.0";

      uptime.prefix = "Uptime: ";
      memory = {
        swap_pos = "below";
      };
      filesystems = {
        boot = "/boot";
        root = "/";
        persist = "/persist";
        nix = "/nix";
        log = "/var/log";
        services = "/var/lib";
      };
      service_status = {
        tailscale = "tailscaled";
        madamoiselle = "madamoiselle";
        audit = "auditd";
        syncthing = "syncthing";
        attic = "atticd";
        caddy = "caddy";
      };
      last_login = {
        "root" = 3;
        "l1npengtul" = 1;
      };
    };
  };

  programs.fish.loginShellInit = ''
    sh ${motdscript}
  '';
}
