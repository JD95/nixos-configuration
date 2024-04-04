{ config, pkgs, ... }: 
let 
  netspec = import ./network-spec.nix;
in {
  services.hydra = {
    enable = true;
    hydraURL = "http://${netspec.hydra.ip}:${netspec.hydra.ip}";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
    extraConfig = ''
      <dynamicruncommand>
        enable = 1
      </dynamicruncommand>
    '';
    
  };

}
