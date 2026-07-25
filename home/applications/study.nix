{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki-bin
    qc
    zotero
    qnotero
  ];

  services.flatpak.packages = [
    "com.logseq.Logseq"
  ];
}
