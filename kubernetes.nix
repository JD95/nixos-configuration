{config, pkgs, ...}:

let 
  kubeMasterIP = "10.1.1.2";
  kubeNodeIP = "10.1.1.3";
  kubeMasterHostName = "kube-master";
  kubeMasterAPIServerPort = 6443;
  kubeApi = "https://${kubeMasterHostName}:${toString kubeMasterAPIServerPort}";
in {
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "ens3";
    enableIPv6 = true;
  };

  containers.kubernetesMaster = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.0.2.15";
    localAddress = kubeMasterIP; 
    config = { config, pkgs, ... }: {

      networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostName}";
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
          advertiseAddress = kubeMasterIP;
        };
      };
    }; 
  };

  containers.kubernetesNode = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.0.2.15";
    localAddress = kubeNodeIP; 
    config = { config, pkgs, ...}: {
      networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostName}";
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

