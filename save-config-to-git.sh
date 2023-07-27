cp /etc/nixos/*.nix $HOME/nixos-configuration
cp /etc/nixos/*.lock $HOME/nixos-configuration
rm $HOME/nixos-configuration/hardware-configuration.nix
chown $USER:users *.nix
chown $USER:users *.lock
