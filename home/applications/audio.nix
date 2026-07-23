{ pkgs, ... }:
{
  #   xdg.dataFile."The Usual Suspects" = {
  #     recursive = true;
  #     source = pkgs.symlinkJoin {
  #       name = "gearmulator-roms";
  #       paths = [gearmulator];
  #     };
  #   };

  services.flatpak.packages = [
    "org.frescobaldi.Frescobaldi"
    "org.musescore.MuseScore"
    "com.rosegardenmusic.rosegarden"
  ];

  home.packages = with pkgs; [
    audacity
    kdePackages.k3b
    strawberry
    kid3-cli
    exiftool

    openutau
    lilypond
  ];
}
