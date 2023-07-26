{ config, pkgs, ... }: 

let 
  netspec = import ./network-spec.nix;
in {
  containers.fitnessServerCi = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = netspec.host.ip;
    localAddress = netspec.fitnessServer.ci.ip; 
  
    config = { config, pkgs, ...}: {
      system.stateVersion = "23.11";
      environment.systemPackages = with pkgs; [
        git
      ];

      environment.etc."resolve.conf".text = "nameserver 8.8.8.8";
    };
  };

}
