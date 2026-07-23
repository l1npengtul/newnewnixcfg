{
  lib,
  pkgs,
  config,
  formats,
  ...
}:
let
  user-cfg = (formats.ini { }).generate "theme.conf.user" null;

  reactionary = pkgs.stdenvNoCC.mkDerivation {
    pname = "sddm-reactionary";
    version = "unstable-2024-02-08";

    src = pkgs.fetchgit {
      url = "https://www.opencode.net/phob1an/reactionary.git";
      rev = "4aa2d20f0e93ae4387a90947fcc6c90940c18122";
      hash = "sha256-obKYi85SEMSvoF9KY8TbU02mag57yr/03TvNNNa67N0=";
    };

    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/sddm/themes"
      cp -r sddm/themes/reactionary "$out/share/sddm/themes/reactionary"
    ''
    + (lib.optionalString (lib.isAttrs null) ''
      ln -sf ${user-cfg} $out/share/sddm/themes/reactionary/theme.conf.user
    '')
    + ''
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
              EnumerateSkipFirst = false;
              ModifierOnlyKeyTimeout = 250;
            };
            "Hotkey/EnumerateForwardKeys" = {
              "0" = "Hangul";
            };
            "Hotkey/EnumerateGroupForwardKeys" = {
              "0" = "Super+space";
            };
            "Hotkey/EnumerateGroupBackwardKeys" = {
              "0" = "Shift+Super+space";
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
              PreeditEnabledByDefault = true;
              ShowInputMethodInformation = true;
              ShowInputMethodInformationWhenFocusIn = false;
              CompactInputMethodInformation = true;
              ShowFirstInputMethodInformation = true;
            };
          };
        };
      };
    };
  };
}
