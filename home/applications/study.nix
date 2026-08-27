{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki-bin
    qc
    zotero
    qnotero
    calibre
  ];

  services.flatpak.packages = [
    "com.logseq.Logseq"
  ];
}
