rec {
  host = { ip = "10.0.2.15"; };

  kube = {
    master = { ip = "10.1.1.2"; };

    node = { ip = "10.1.1.3"; };
  };

  fitnessServer = {
    ci = { ip = "10.1.1.4"; };
  };

  forwardPorts = [ 
   { destination = "${fitnessServer.ci.ip}:80"; sourcePort = 80; }
  ];
}
