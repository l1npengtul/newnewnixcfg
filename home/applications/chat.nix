{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs; [
    pkgs-unstable.legcord
    kdePackages.konversation
    discordo
  ];
}
