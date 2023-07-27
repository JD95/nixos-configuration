{ config, pkgs, ... }: 

let 
  netspec = import ./network-spec.nix;
in {

  containers.scratchWork = {
    autoStart = true;
    config = { config, pkgs, ... }: {
      environment.etc."resolve.conf".text = "nameserver 8.8.8.8";
      system.stateVersion = "23.11";
      nix = {
        settings.sandbox = "relaxed";
        package = pkgs.nixFlakes;
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
      };
      users.users.scratch = {
       isNormalUser = true;
      };
      environment.systemPackages = with pkgs; [
        git vim
      ];
    };
  };

  containers.fitnessServerCi = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = netspec.host.ip;
    localAddress = netspec.fitnessServer.ci.ip; 
  
    config = { config, pkgs, ...}: {
      environment.etc."resolve.conf".text = "nameserver 8.8.8.8";
      system.stateVersion = "23.11";
      environment.systemPackages = with pkgs; [
        git
      ];
    };
  };

}
