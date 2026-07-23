{ inputs, ... }:
let
  shhh = builtins.toString inputs.shhh;
in
{
  sops = {
    defaultSopsFile = "${shhh}/secrets.yaml";
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/persist/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
