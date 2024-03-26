rec {
  host = { ip = "10.0.2.15"; };

  hydra = {
    ip = "localhost";
    port = "3000";
  };

  kube = {
    master = { ip = "10.1.1.2"; };

    node = { ip = "10.1.1.3"; };
  };

  docker-registry = { port = 3001; };

  fitnessServer = {
    ci = { ip = "10.1.1.4"; };
  };

  scratchWork = {
    ip = "10.1.1.5";
  };

  forwardPorts = [ 
   { destination = "${fitnessServer.ci.ip}:80"; sourcePort = 80; }
  ];
}
