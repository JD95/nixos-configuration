{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";
  home.username = "jeff";
  home.homeDirectory = "/home/jeff";
  home.packages = [];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export EDITOR="vim"
    '';
  };
  programs.git = {
    enable = true;
    userName = "Jeffrey Dwyer";
    userEmail = "jeffreydwyer95@outlook.com";
  };
}
