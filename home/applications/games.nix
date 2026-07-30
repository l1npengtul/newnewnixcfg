{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pcsx2
    #rpcs3
    azahar
    (prismlauncher.override {
    # Add binary required by some mod
    additionalPrograms = [ ffmpeg ];

    # Change Java runtimes available to Prism Launcher
    jdks = [
      graalvmPackages.graalvm-ce
      zulu8
      zulu17
      zulu
    ];
  })
  ];

  services.flatpak.packages = [
    "at.vintagestory.VintageStory"
    "org.duckstation.DuckStation"
  ];
}
