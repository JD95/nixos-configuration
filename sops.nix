{ config, pkgs, lib, ...}:

{
  sops = {
    defaultSopsFile = ./secrets/vault.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      "nextcloud/password" = {
        owner = config.users.users.jeff.name;
        mode = "0400";
        path = "/home/jeff/nextcloud.txt";
      };
      "dockerhub/password" = {
        owner = config.users.users.hydra-queue-runner.name;
        group = config.users.users.hydra-queue-runner.group;
        mode = "0440";
        path = "/home/hydra/hydra-queue-runner/dockerhub.txt";
      };
    };
  };
}
