{config, pkgs, ...}:

{
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

  users.users.jeff.openssh.authorizedKeys.keyFiles = [
    ./ssh/authorized_keys
  ];
}
