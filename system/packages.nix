{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  paulxstretch = pkgs-unstable.callPackage ./vsts/paulxstretch.nix { };
  ripplerx = pkgs-unstable.callPackage ./vsts/ripplerx.nix { };
  neuralnote = pkgs-unstable.callPackage ./vsts/neuralnote.nix { };
  sfzq = pkgs-unstable.callPackage ./vsts/sfzq { };
  pianoteq = pkgs-unstable.callPackage ./vsts/pianoteq.nix { };

  rosegarden-hidpi =
    pkgs-unstable.runCommand "rosegarden"
      {
        buildInputs = [ pkgs-unstable.makeWrapper ];
      }
      ''
        mkdir $out
        # Link every top-level folder from pkgs.hello to our new target
        ln -s ${pkgs-unstable.rosegarden}/* $out
        # Except the bin folder
        rm $out/bin
        mkdir $out/bin
        # We create the bin folder ourselves and link every binary in it
        ln -s ${pkgs-unstable.rosegarden}/bin/* $out/bin
        # Except the hello rosegarden
        rm $out/bin/rosegarden
        # Because we create this ourself, by creating a wrapper
        makeWrapper ${pkgs-unstable.rosegarden}/bin/rosegarden $out/bin/rosegarden \
          --set QT_SCALE_FACTOR 2
      '';

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
    mosh
  ];
  keyboard = with pkgs; [
    via
    vial
    zmk-studio
    ungoogled-chromium
  ];
  programming = with pkgs; [
    distrobox
    android-tools
    universal-android-debloater
    gram.remote_server
    nix-prefetch-github
    nixpkgs-fmt
    nixfmt
    nil
    patchelf
    lldb
    lld
    rkdeveloptool
    usbutils
    nixpkgs-review
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
    unetbootin
    e2fsprogs
    exfatprogs
    smartmontools
  ];
  udf = with pkgs; [ udftools ];
  gaming = with pkgs; [
    r2modman
    heroic
  ];
  music = with pkgs-unstable; [
    bitwig-studio6
    reaper
    bottles
    yabridgectl
    yabridge
    wineWow64Packages.yabridge
    sonic-visualiser
    lilypond
    openutau
    rosegarden-hidpi

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
    dxvk_2
    plugdata
    carla
    ysfx

    airwindows
    airwin2rack
    socalabs-sid
    socalabs-sn76489
    socalabs-papu
    socalabs-rp2a03
    socalabs-voc
    decent-sampler
    friture
    x42-plugins
    x42-gmsynth
    x42-avldrums
    meters-lv2
    sfizz
    fluidsynth
    qsynth
    fluida-lv2

    flac

    calf
    sfzq

    adlplug
    opnplug

    bespokesynth
    oxefmsynth

    sorcer

    bjumblr
    bslizr
    bshapr
    ingen
    infamousplugins
    caps
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

    (pianoteq.overrideAttrs {
      src = "${inputs.randomshit}/pianoteq_setup_v921.tar.xz";
    })
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
    environment.systemPackages =
      base
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

    boot.initrd.kernelModules =
      [ ]
      ++ lib.lists.optionals cfg.udf.enable [
        "udf"
        "sg"
      ];

    programs.appimage = lib.mkIf cfg.appimage.enable {
      enable = true;
      binfmt = true;
    };

    programs.steam = lib.mkIf cfg.gaming.enable {
      enable = true;
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    programs.nix-ld = lib.mkIf cfg.gaming.enable {
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
