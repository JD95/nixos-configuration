{config, pkgs, ...}:

let 
  netspec = import ./network-spec.nix;
  kubeMasterHostName = "kube-master";
  kubeMasterAPIServerPort = 6443;
  kubeApi = "https://${kubeMasterHostName}:${toString kubeMasterAPIServerPort}";
in {

  containers.kubernetesMaster = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = netspec.host.ip; 
    localAddress = netspec.kube.master.ip;
    config = { config, pkgs, ... }: {

      networking.extraHosts = "${netspec.kube.master.ip} ${kubeMasterHostName}";
      system.stateVersion = "23.11";
  
      environment.systemPackages = with pkgs; [
        kubectl
        kubernetes
      ]; 

      environment.etc."resolve.conf".text = "nameserver 8.8.8.8";

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
  };

  containers.kubernetesNode = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = netspec.host.ip; 
    localAddress = netspec.kube.node.ip; 
    config = { config, pkgs, ...}: {
      networking.extraHosts = "${netspec.kube.master.ip} ${kubeMasterHostName}";
      system.stateVersion = "23.11";
      environment.etc."resolve.conf".text = "nameserver 8.8.8.8";
      environment.systemPackages = with pkgs; [
        kubectl
        kubernetes
      ]; 
      services.kubernetes = {
        roles = ["node"];
        masterAddress = kubeMasterHostName;
        easyCerts = true;
        kubelet.kubeconfig.server = kubeApi;
        apiserverAddress = kubeApi;
        addons.dns.enable = true;
      };
    };
  };
}

