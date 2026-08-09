{
  lib,
  pkgs,
  config,
  ...
}:
let
  reactionary = pkgs.stdenvNoCC.mkDerivation {
    pname = "reactionary";
    version = "unstable-2026-03-17";

    src = pkgs.fetchgit {
      url = "https://www.opencode.net/phob1an/reactionary.git";
      rev = "d02946110b87c9c61607ff4913dcbf9d070f6b6a";
      hash = "sha256-u74Mpdj57Ze5uz8vcLOcdvhMEzDfbnjqBJ8qD2/156s=";
    };

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/sddm/themes"
      cp -r sddm/themes/reactionary "$out/share/sddm/themes/reactionary"

      runHook postInstall
    '';
    meta = {
      description = "Reactionary SDDM Theme";
      homepage = "https://www.opencode.net/phob1an/reactionary";
      license = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [ l1npengtul ];
    };
  };
in
{
  options = {
    services.kde-desktop.enable = lib.mkEnableOption "enable the KDE desktop and reactionary theme";
  };

  config = lib.mkIf config.services.kde-desktop.enable {
    programs.kdeconnect.enable = true;
    networking.firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };

    services = {
      desktopManager.plasma6.enable = true;

      displayManager = {
        sddm = {
          enable = true;
          theme = "reactionary";
          extraPackages = [ reactionary ];
          wayland.enable = true;
        };
        defaultSession = "plasma";
      };

      xserver.desktopManager.runXdgAutostartIfNone = true;
    };

    programs.xwayland.enable = true;

    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocales = [
      "ja_JP.UTF-8/UTF-8"
      "ko_KR.UTF-8/UTF-8"
    ];
    i18n.extraLocaleSettings = {
      LC_CTYPE = "ja_JP.UTF-8";
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MESSAGES = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          kdePackages.fcitx5-qt
          fcitx5-mozc
          fcitx5-hangul
        ];

        ignoreUserConfig = true;

        settings = {
          inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "hangul";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "hangul";
            "Groups/0/Items/2".Name = "mozc";
          };
          globalOptions = {
            Hotkey = {
              EnumerateWithTriggerKeys = true;
              ActivateKeys = "";
              DeactivateKeys = "";
              AltTriggerKeys = "";
              EnumerateBackwardKeys = "";
              EnumerateSkipFirst = false;
              EnumerateGroupForwardKeys = "";
              EnumerateGroupBackwardKeys = "";
              ModifierOnlyKeyTimeout = 250;
            };

            "Hotkey/TriggerKeys" = {
              "0" = "Hangul";
            };
            "Hotkey/EnumerateForwardKeys" = {
              "0" = "Hiragana_Katakana";
            };
            "Hotkey/PrevPage" = {
              "0" = "Up";
            };
            "Hotkey/NextPage" = {
              "0" = "Down";
            };
            "Hotkey/PrevCandidate" = {
              "0" = "Shift+Tab";
            };
            "Hotkey/NextCandidate" = {
              "0" = "Tab";
            };
            "Hotkey/TogglePreedit" = {
              "0" = "Control+Alt+P";
            };

            Behavior = {
              ActiveByDefault = false;
              resetStateWhenFocusIn = "No";
              ShareInputState = "No";
              PreeditEnabledByDefault = true;
              ShowInputMethodInformation = true;
              showInputMethodInformationWhenFocusIn = false;
              CompactInputMethodInformation = true;
              ShowFirstInputMethodInformation = true;
              DefaultPageSize = 5;
              OverrideXkbOption = false;
              CustomXkbOption = "";
              EnabledAddons = "";
              DisabledAddons = "";
              PreloadInputMethod = true;
              AllowInputMethodForPassword = false;
              ShowPreeditForPassword = false;
            };
          };
        };
      };
    };
  };
}
