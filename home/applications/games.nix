{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pcsx2
    #rpcs3
    azahar
    prismlauncher
  ];

  services.flatpak.packages = [
    "at.vintagestory.VintageStory"
    "org.duckstation.DuckStation"
  ];
}
