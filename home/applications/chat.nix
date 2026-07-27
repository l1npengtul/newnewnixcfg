{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs; [
    pkgs-unstable.legcord
    pkgs-unstable.discord-canary
    kdePackages.konversation
    discordo
  ];
}
