{ inputs, pkgs, ... }:
let
  randomshit = builtins.toString inputs.randomshit;

  mkDict =
    {
      pname,
      readmeFile,
      dictFileName,
      ...
    }@args:
    pkgs.stdenv.mkDerivation (
      {
        inherit pname;
        installPhase = ''
          runHook preInstall
          # hunspell dicts
          install -dm755 "$out/share/hunspell"
          install -m644 ${dictFileName}.dic "$out/share/hunspell/"
          install -m644 ${dictFileName}.aff "$out/share/hunspell/"
          # myspell dicts symlinks
          install -dm755 "$out/share/myspell/dicts"
          ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
          ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
          # docs
          install -dm755 "$out/share/doc"
          install -m644 ${readmeFile} $out/share/doc/${pname}.txt
          runHook postInstall
        '';
      }
      // args
    );

  dict-ja-jp = mkDict {
    pname = "hunspell-dict-ja-jp";
    version = "0-unstable-2026-08-09";

    src = pkgs.fetchFromGitHub {
      owner = "MrCorn0-0";
      repo = "hunspell_ja_JP";
      rev = "80fc8a8ae1ad6aa286be8fe3e36b3c21964f8d22";
      hash = "sha256-mhOktnACVwmaPhTd/rz3Ng8E41ufWZmV6T8s8NKY/xY=";
    };

    readmeFile = "README.md";

    dictFileName = "ja_JP";
  };
in
{
  xdg.dataFile."icons/Chicago95".source = "${inputs.chicago95}/Icons/Chicago95";
  xdg.dataFile."icons/miku-cursor-linux".source =
    "${inputs.hatsune-miku-windows-linux-cursors}/miku-cursor-linux";
  xdg.dataFile."color-schemes/PlasmaOverdose.colors".source =
    "${inputs.plasma-overdose}/colorschemes/PlasmaOverdose.colors";
  xdg.dataFile."sounds/Plasma-Overdose".source = "${inputs.plasma-overdose}/sounds";
  xdg.dataFile."aurorae/themes/Plasma-Overdose" = {
    recursive = true;
    source = "${inputs.plasma-overdose}/aurorae/Plasma-Overdose";
  };
  xdg.dataFile."plasma/look-and-feel/Plasma-Overdose".source =
    "${inputs.plasma-overdose}/plasma/look-and-feel/Plasma-Overdose";

  programs.plasma = {
    enable = true;

    #     input = {
    #       touchPadType = {
    #         enable = true;
    #         disableWhileTyping = true;
    #         middleButtonEmulation = true;
    #         naturalScroll = true;
    #         tapToClick = true;
    #         twoFingerTap = "rightClick";
    #         scrollMethod = "twoFingers";
    #       };
    #       mouseType = {
    #         enable = true;
    #
    #       };
    #     };

    workspace = {
      colorScheme = "PlasmaOverdose";
      iconTheme = "Chicago95";
      soundTheme = "PlasmaOverdose";
      splashScreen = {
        theme = "PlasmaOverdose";
      };
      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__Plasma-Overdose_x1.5";
      };
      cursor = {
        theme = "miku-cursor-linux";
      };
      wallpaper = "${randomshit}/wpadwa.jpg";
    };

    powerdevil = {
      general.pausePlayersOnSuspend = true;
      AC = {
        powerButtonAction = "lockScreen";
        turnOffDisplay = {
          idleTimeout = 300;
          idleTimeoutWhenLocked = "immediately";
        };
        dimDisplay.enable = true;
        autoSuspend.action = "nothing";
      };
      battery = {
        powerButtonAction = "sleep";
        whenSleepingEnter = "standby";
      };
      lowBattery = {
        whenLaptopLidClosed = "sleep";
      };
    };

    shortcuts = {
      "kwin"."karousel-window-move-next" = "Meta+Right";
      "kwin"."karousel-window-move-previous" = "Meta+Left";
      "kwin"."karousel-window-toggle-floating" = "Meta+F";
    };
    configFile = {
      katerc.filetree.middleClickToClose = true;
      katerc.lspclient.FormatOnSave = true;
      kcminputrc."ButtonRebinds/Tablet/HUION Huion Tablet_GS1331"."0" = "Key,Ctrl+Z";
      kcminputrc."ButtonRebinds/Tablet/HUION Huion Tablet_GS1331"."1" = "Key,Ctrl+Shift+Z";
      kcminputrc."ButtonRebinds/Tablet/HUION Huion Tablet_GS1331"."2" = "Key,E";
      kcminputrc."ButtonRebinds/Tablet/HUION Huion Tablet_GS1331"."3" = "Key,Ctrl+=";
      kcminputrc."ButtonRebinds/Tablet/HUION Huion Tablet_GS1331"."4" = "Key,Ctrl+-";
      kcminputrc."ButtonRebinds/Tablet/HUION Huion Tablet_GS1331"."5" = "Key,M";
      kcminputrc."ButtonRebinds/Tablet/HUION Huion Tablet_GS1331"."6" = "Key,[";
      kcminputrc."ButtonRebinds/Tablet/HUION Huion Tablet_GS1331"."7" = "Key,]";
      kcminputrc."Libinput/9580/109/HUION Huion Tablet_GS1331 Dial".Enabled = false;
      kcminputrc."Libinput/9580/109/HUION Huion Tablet_GS1331 Stylus".MapToWorkspace = false;
      "kxkbrc"."Layout"."Options" = "korean:ralt_hangul,korean:rctrl_hanja,caps:backspace";
      kded5rc.Module-browserintegrationreminder.autoload = false;
      kded5rc.Module-device_automounter.autoload = false;

      kdeglobals.General.XftHintStyle = "hintslight";
      kdeglobals.General.XftSubPixel = "none";
      kdeglobals.General.fixed = "ComicShannsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      kdeglobals.General.font = "rainyhearts,12,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Medium";
      kdeglobals.General.menuFont = "rainyhearts,12,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Medium";
      kdeglobals.General.smallestReadableFont = "rainyhearts,10,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Medium";
      kdeglobals.General.toolBarFont = "rainyhearts,12,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Medium";
      kdeglobals.Icons.Theme = "Chicago95";
      kdeglobals.KDE.AnimationDurationFactor = 0.125;
      kdeglobals.KDE.contrast = 2;
      kdeglobals.KDE.frameContrast = 0.2;
      kdeglobals.KDE.widgetStyle = "Windows";
      kdeglobals."KFileDialog Settings"."Allow Expansion" = false;
      kdeglobals."KFileDialog Settings"."Automatically select filename extension" = true;
      kdeglobals."KFileDialog Settings"."Breadcrumb Navigation" = true;
      kdeglobals."KFileDialog Settings"."Decoration position" = 2;
      kdeglobals."KFileDialog Settings"."Show Full Path" = false;
      kdeglobals."KFileDialog Settings"."Show Inline Previews" = true;
      kdeglobals."KFileDialog Settings"."Show Preview" = false;
      kdeglobals."KFileDialog Settings"."Show Speedbar" = true;
      kdeglobals."KFileDialog Settings"."Show hidden files" = false;
      kdeglobals."KFileDialog Settings"."Sort by" = "Name";
      kdeglobals."KFileDialog Settings"."Sort directories first" = true;
      kdeglobals."KFileDialog Settings"."Sort hidden files last" = false;
      kdeglobals."KFileDialog Settings"."Sort reversed" = false;
      kdeglobals."KFileDialog Settings"."Speedbar Width" = 140;
      kdeglobals."KFileDialog Settings"."View Style" = "DetailTree";

      kdeglobals.Sounds.Theme = "PlasmaOverdose";
      ksmserverrc.General.loginMode = "emptySession";
      klipperrc.General.IgnoreImages = false;
      klipperrc.General.KeepClipboardContents = false;
      ksplashrc.KSplash.Engine = "KSplashQML";
      ksplashrc.KSplash.Theme = "PlasmaOverdose";
      kwinrc.Wayland."InputMethod[$e]" =
        "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
      kwinrc.Wayland."InputMethod\x5b$e\x5d" =
        "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
      kwinrc.Wayland.VirtualKeyboardEnabled = true;
      kwinrc.Windows.FocusPolicy = "FocusFollowsMouse";
      kwinrc.Desktops.Number = {
        value = 4;
        # Forces kde to not change this value (even through the settings app).
        immutable = true;
      };
      kwinrc."org.kde.kdecoration2".theme = "__aurorae__svg__Plasma-Overdose_x1.5";
      spectaclerc.ImageSave.translatedScreenshotsFolder = "Screenshots";
      spectaclerc.VideoSave.translatedScreencastsFolder = "Screencasts";
      yakuakerc.Dialogs.FirstRun = false;
      plasma-localerc.Formats.LANG = "en_US.UTF-8";
      plasmanotifyrc."Applications/com.usebottles.bottles".Seen = true;
      plasmanotifyrc."Applications/firefox-devedition".Seen = true;
    };
  };

  home.packages = with pkgs; [
    kdePackages.ark
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kompare
    kdePackages.yakuake
    kdePackages.discover
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.sddm-kcm
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
    kdePackages.filelight
    kdePackages.kamera
    kdePackages.spectacle
    kdePackages.gwenview

    wayland-utils
    wl-clipboard

    plasma-overdose-kde-theme

    hunspell
    hunspellDicts.en-gb-large
    hunspellDicts.ko_KR
    dict-ja-jp
  ];

  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };
}
