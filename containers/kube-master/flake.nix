{
  inputs.extra-container.url = "github:erikarvstedt/extra-container";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { extra-container, ...}@inputs:
    let 
      netspec = import ../../network-spec.nix;
      kubeMasterHostName = "kube-master";
      kubeMasterAPIServerPort = 6443;
      kubeApi = "https://${kubeMasterHostName}:${toString kubeMasterAPIServerPort}";
    
      kube-config = {pkgs, ...}: { 
        networking.extraHosts = "${netspec.kube.master.ip} ${kubeMasterHostName}";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        system.stateVersion = "23.05";
        
        environment.systemPackages = with pkgs; [
          kubectl
          kubernetes
          git
        ]; 
       
        users.users.kube = {
          isNormalUser = true;
          home = "/home/kube";
          extraGroups = [ "wheel" ];
        };
       
        services.kubernetes = {
          roles = ["master" "node"];
          masterAddress = kubeMasterHostName;
          apiserverAddress = kubeApi; 
          easyCerts = true;
          addons.dns.enable = true;
       
          apiserver = {
            securePort = kubeMasterAPIServerPort;
            advertiseAddress = netspec.kube.master.ip;
          };
        };
      };

      container-config = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = netspec.host.ip; 
        localAddress = netspec.kube.master.ip;
        extra = {
          enableWAN = true;
          firewallAllowHost = true;
          exposeLocalhost = true;
        };
        config = kube-config;
      };

    in extra-container.inputs.flake-utils.lib.eachSystem extra-container.lib.supportedSystems (system: {
      packages.default = extra-container.lib.buildContainers {
        inherit system;
        nixpkgs = inputs.nixpkgs;
        config = { containers.kube = container-config; }; 
     };
    });
}
