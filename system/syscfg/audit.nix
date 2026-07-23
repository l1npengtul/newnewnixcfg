{ lib, config, ... }: {
  options = {
    services.audit-auditd.enable = lib.mkEnableOption "enable auditd";
  };

  config = lib.mkIf config.services.audit-auditd.enable {
    security.auditd.enable = true;
    security.audit.enable = true;
    security.audit.rules = [
      "-a exit,always -F arch=b64 -S execve"
    ];
  };
}
