{...}: {
  fileSystems."/".options = ["noexec"];
  fileSystems."/etc/nixos".options = ["noexec"];
  fileSystems."/var/log".options = ["noexec"];
}
