{ ... }: {
  home.persistence."/persist" = {
    directories = [
      "Downloads"
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
    ];
  };

}
