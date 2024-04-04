{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./kubernetes.nix
      ./ssh.nix
      ./project-ci.nix
      ./networking.nix
      ./hydra.nix
      ./docker-registry.nix
      ./cron.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    settings.sandbox = "relaxed";
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

  };

  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.enable = true;

  users.users.jeff = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; 
  };

  users.extraGroups.docker.members = ["jeff"];

  environment.systemPackages = with pkgs; [
    git wget curl vim tmux lsof inetutils strace
    watch jq skopeo ssh-to-age sops 
  ];

  system.stateVersion = "20.09"; 
}
