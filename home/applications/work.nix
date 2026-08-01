{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
let
  rpgm-archive-decrypter = pkgs.callPackage ./rpgm/rpgm-archive-decrypter.nix { };
  rvpacker-txt-rs = pkgs.callPackage ./rvpacker/rvpacker-txt-rs.nix { };
  trenchbroom = pkgs-unstable.callPackage ./trenchbroom/package.nix { };
in
{
  home.packages = with pkgs; [
    blender
    darktable
    krita
    rpgm-archive-decrypter
    rvpacker-txt-rs
    inkscape
    scribus
    proton-vpn
    gimp
    trenchbroom

    libreoffice-qt
    hunspell
    hyphenDicts.all
    hunspellDicts.ko-kr
    hunspellDicts.en-gb-large
  ];
  programs.obs-studio = {
    enable = true;
  };
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    package = pkgs.firefox-devedition;
  };
  programs.thunderbird = {
    enable = true;
    profiles."default".isDefault = true;
    settings = {
      "app.update.auto" = false;
      "calendar.alarms.eventalarmlen" = 0;
      "calendar.alarms.onforevents" = 1;
      "calendar.alarms.onfortodos" = 1;
      "calendar.alarms.playsound" = false;
      "calendar.alarms.todoalarmlen" = 0;
      "calendar.event.defaultlength" = 30;
      "calendar.events.defaultActionEdit" = true;
      "calendar.item.editInTab" = true;
      "calendar.task.defaultdueoffset" = 0;
      "calendar.task.defaultdue" = "offsetcurrent";
      "calendar.timezone.local" = "Europe/Copenhagen";
      "calendar.timezone.useSystemTimezone" = true;
      "calendar.view.visiblehours" = 14;
      "mail.biff.play_sound" = false;
      "mail.biff.show_alert" = false;
      "mailnews.start_page.enabled" = false;
      "mail.shell.checkDefaultClient" = false;
      "privacy.donottrackheader.enabled" = true;
    };
  };

  services.protonmail-bridge.enable = true;

}
