{ pkgs, ... }: {
  home.packages = with pkgs; [
    legcord
    kdePackages.konversation
    discordo
  ];
}
