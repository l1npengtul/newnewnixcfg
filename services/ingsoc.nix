{
  lib,
  config,
  options,
  pkgs,
  inputs,
  ...
}:
let
  theanofiles = builtins.toString inputs.theanofiles;

  notify = pkgs.writeShellScript "ssh-login-notify-webhook" ''
    set -euo pipefail

    WEBHOOK=$(${pkgs.coreutils}/bin/cat ${
      config.sops.secrets."ingsoc/${config.networking.hostName}".path
    })
    PAYLOAD="{\"content\":\"$PAM_USER from $PAM_RHOST at $(${pkgs.coreutils}/bin/date +%c): $PAM_TYPE into/from server ${config.networking.hostName}\",\"username\":\"racist-callum-o-brien@${config.networking.hostName}\",\"avatar_url\":\"https://vzge.me/face/512/911a950a-839d-4150-bfe8-d901a3b85316.png\"}"

    echo $WEBHOOK
    echo $PAYLOAD

    ${pkgs.curl}/bin/curl -H "Accept: application/json" -H "Content-Type: application/json" -s -X POST --fail --silent --show-error --max-time 10 --retry 1 --data "$PAYLOAD" "$WEBHOOK" &
  '';
  cfg = config.security.ingsoc;
in
{
  options.security.ingsoc = {
    enable = lib.mkEnableOption "Enable PAM Watcher";
    discordNotifyRole = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "role to ping when login";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."ingsoc/${config.networking.hostName}" = {
      sopsFile = "${theanofiles}/secrets/ingsoc.yaml";
      mode = "0444";
    };

    security.pam.services.sshd.rules.session.ingsoc = {
      order = 10000;
      control = "optional";
      modulePath = "${pkgs.pam}/lib/security/pam_motd.so";
      args = [
        "quiet"
        (builtins.toString notify)
      ];
    };
  };
}
