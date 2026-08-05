{ ... }: {
  home.persistence."/persist" = {
    directories = [
      "everything"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "Projects"
      "supernote"
      {
        directory = ".ssh";
        mode = "0700";
      }
      "Zotero"
      ".BitwigStudio"
      ".config"
      ".local"
      ".logseq"
      ".MakeMKV"
      ".steam"
      ".TrenchBroom"
      ".vst"
      ".vst3"
      ".var"
      ".wine"
    ];
  };

  #home.file.".wine/.stignore".source = ./stignores/stignore-wine;
  #home.file."Documents/.stignore".source = ./stignores/stignore-std;
  #home.file."Music/.stignore".source = ./stignores/stignore-std;
  #home.file."Pictures/.stignore".source = ./stignores/stignore-std;
  #home.file."supernote/.stignore".source = ./stignores/stignore-std;

  systemd.user.tmpfiles.rules = [
    "d /home/l1npengtul/Downloads 0755 l1npengtul users -"
  ];
}
