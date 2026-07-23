{ ... }: {
  imports = [
    ./audio.nix
    ./battery.nix
    ./gpu.nix
    ./optical.nix
    ./printer.nix
    ./scanner.nix

    ./libinput.nix
  ];
}
