{ pkgs, ... }: {
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    anki-bin
    qc
    zotero
    qnotero
  ];

  services.flatpak.packages = [
    "com.logseq.Logseq"
  ];
}
