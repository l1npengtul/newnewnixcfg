{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs; [
    pkgs-unstable.anki
    qc
    zotero
    qnotero
    calibre
  ];

  services.flatpak.packages = [
    "com.logseq.Logseq"
  ];
}
