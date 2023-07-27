{ config, pkgs, ... }: 

let 
  netspec = import ./network-spec.nix;
in {
  
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 ];
  };
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "ens3";
    enableIPv6 = true;
    forwardPorts = netspec.forwardPorts;
  };
}
