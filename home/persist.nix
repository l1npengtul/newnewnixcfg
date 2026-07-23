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
      {
        directory = ".ssh";
        mode = "0700";
      }
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
