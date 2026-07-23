{ pkgs, ... }:
let
  rainyhearts = pkgs.callPackage ./rainyhearts { };
  dalmoori = pkgs.callPackage ./dalmoori.nix { };
  pixelmplus = pkgs.callPackage ./pixelmplus.nix { };
  libre-moretus = pkgs.callPackage ./libre-moretus.nix { };
  minipax = pkgs.callPackage ./minipax.nix { };
in
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf
    fira-code
    fira-code-symbols
    proggyfonts
    nerd-fonts.comic-shanns-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    rainyhearts
    dalmoori
    pixelmplus
    fira
    fira-mono
    roboto
    libertine
    gelasio
    ibm-plex
    libre-moretus
    minipax
  ];

  fonts.enableDefaultPackages = true;
  fonts.enableGhostscriptFonts = true;

  fonts.fontDir.enable = true;

  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [
        "rainyhearts"
        "Noto Sans CJK JP"
        "Noto Sans CJK KR"
      ];
      monospace = [
        "ComicShannsMono Nerd Font Mono"
        "Noto Sans Mono CJK JP"
        "Noto Sans Mono CJK KR"
      ];
    };
  };
}
