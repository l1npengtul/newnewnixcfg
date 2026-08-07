{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  supernote-tool =
in
{
  options = {
    services.supernote-watcher.enable = lib.mkEnableOption "enable supernote service";
  };

  config = lib.mkIf config.services.supernote-watcher.enable {
    environment.systemPackages = [
      supernote-batch
      supernote-watcher
    ];
  };
}
