{
  inputs,
  config,
  pkgs,
  ...
}:
let
  shhh = builtins.toString inputs.shhh;
in
{
  users.users.l1npengtul = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = inputs.shhh.authorized-keys;
    hashedPasswordFile = config.sops.secrets."passwords/${config.networking.hostName}".path;
    extraGroups = [
      "wheel"
      "docker"
      "libvirtd"
      "networkmanager"
      "video"
      "audio"
      "input"
      "jackaudio"
      "adbusers"
      "kvm"
      "scanner"
      "lp"
      "cdrom"
      "gamemode"
      "optical"
      "realtime"
    ];
  };
  programs.fish.enable = true;
  sops.age.sshKeyPaths = inputs.shhh.sops-ssh-paths;
  sops.secrets."passwords/${config.networking.hostName}" = {
    sopsFile = "${shhh}/secrets.yaml";
    neededForUsers = true;
  };
  security.sudo.wheelNeedsPassword = false;
}
