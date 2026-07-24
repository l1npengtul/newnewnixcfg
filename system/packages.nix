{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  paulxstretch = pkgs.callPackage ./vsts/paulxstretch.nix { };
  ripplerx = pkgs.callPackage ./vsts/ripplerx.nix { };
  neuralnote = pkgs.callPackage ./vsts/neuralnote.nix { };
  sfzq = pkgs.callPackage ./vsts/sfzq { };

  base = with pkgs; [
    # nix utilities
    nixfmt-tree
    nix-update
    nix-du
    nix-prefetch
    nix-prefetch-scripts
    # system utilities
    binutils
    tmux
    zenith
    fishPlugins.grc
    ssh-to-age
    sops
    openssl
    p7zip-rar
    unar
    ripgrep-all
    unzip
    pciutils
  ];
  keyboard = with pkgs; [
    via
    vial
    zmk-studio
    ungoogled-chromium
  ];
  programming = with pkgs; [
    python3
    temurin-bin
    jdk8
    distrobox
    android-tools
    mosh
    gram.remote_server
  ];
  diskmgmt = with pkgs; [
    util-linux
    gptfdisk
    gparted
    btrfs-progs
    zfs
    zfstools
    ntfs3g
    woeusb-ng
  ];
  udf = with pkgs; [ udftools ];
  gaming = with pkgs; [
    r2modman
    heroic
  ];
  music = with pkgs; [
    odin2
    surge-xt
    lsp-plugins
    qpwgraph
    dexed
    setbfree
    zynaddsubfx
    audacity
    musescore
    paulstretch
    zam-plugins
    chow-tape-model
    chow-kick
    #vcv-rack
    cardinal
    alsa-utils
    vital
    distrho-ports
    yabridgectl
    yabridge
    wineWow64Packages.stagingFull
    dxvk_2
    plugdata
    carla
    reaper
    reaper-sws-extension
    reaper-reapack-extension

    airwindows
    airwin2rack
    socalabs-sid
    socalabs-sn76489
    socalabs-papu
    socalabs-rp2a03
    socalabs-voc
    decent-sampler
    friture

    flac

    calf
    sfzq

    adlplug
    opnplug

    bespokesynth
    oxefmsynth

    bjumblr
    bslizr
    ingen
    infamousplugins
    caps
    eq10q
    csa
    aeolus
    aeolus-stops

    ninjas2
    drum-machine
    drumgizmo
    drumkv1

    paulxstretch
    ripplerx
    inputs.audio.packages.${pkgs.stdenv.hostPlatform.system}.atlas2
    neuralnote
  ];
  cfg = config.programs.sets;
in
{
  options = {
    programs.sets = {
      enable = lib.mkEnableOption "enable";
      keyboard.enable = lib.mkEnableOption "enable keyboard management programs";
      programming.enable = lib.mkEnableOption "enable basic programming things";
      diskmgmt.enable = lib.mkEnableOption "disk management programs";
      udf.enable = lib.mkEnableOption "enable mounting UDF disks";
      appimage.enable = lib.mkEnableOption "enable appimage support";
      gaming.enable = lib.mkEnableOption "enable games and stuff";
      music.enable = lib.mkEnableOption "enable music production stuff";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = base
      ++ lib.lists.optionals cfg.keyboard.enable keyboard
      ++ lib.lists.optionals cfg.programming.enable programming
      ++ lib.lists.optionals cfg.diskmgmt.enable diskmgmt
      ++ lib.lists.optionals cfg.udf.enable udf
      ++ lib.lists.optionals cfg.gaming.enable gaming
      ++ lib.lists.optionals cfg.music.enable music;

    services.udev.packages = [ ] ++ lib.lists.optionals cfg.keyboard.enable keyboard;

    programs.git = lib.mkIf cfg.programming.enable {
      enable = true;
      lfs.enable = true;
    };

    programs.appimage = lib.mkIf cfg.appimage.enable {
      enable = true;
      binfmt = true;
    };

    programs.steam = lib.mkIf cfg.gaming.enable {
      enable = true;
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    programs.nix-ld = lib.mkIf cfg.gaming.enable  {
      enable = true;
      libraries = [
        (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      ];
    };

    hardware.steam-hardware = lib.mkIf cfg.gaming.enable {
      enable = true;
    };
  };
}
