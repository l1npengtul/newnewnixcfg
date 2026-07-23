{pkgs, ...}: {
  home.packages = with pkgs; [
    filezilla
    kdePackages.ktorrent
    yt-dlp
  ];
}
