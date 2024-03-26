{ config, pkgs, ... }:

let 
  network-spec = import ./network-spec.nix;
  listenAddress = network-spec.host.ip;
  port = network-spec.docker-registry.port;
in {
  services.dockerRegistry = {
    enable = true;  
    inherit port; 
    inherit listenAddress;
  };
  networking.firewall.allowedTCPPorts = [ port ];
}
