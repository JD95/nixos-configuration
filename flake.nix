{
  description = "Configuration for my home vm";

  inputs = {

    nixpkgsRegistry.url = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-bundle.url = "github:NixOS/bundlers";
  
    sops-nix = {
      url = "github:mic92/sops-nix?rev=7f49111254333bda6881b0dfa8cf7d82fe305f93";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 
    nix-inspect.url = "github:bluskript/nix-inspect";
  };

  outputs = inputs@{ self, nixpkgs, sops-nix, home-manager, nix-bundle, ... }: {

    # Utilized by `nix bundle -- .#<name>` (should be a .drv input, not program path?)
    bundlers.x86_64-linux.example = nix-bundle.bundlers.x86_64-linux.toArx;

    # Utilized by `nix bundle -- .#<name>`
    defaultBundler.x86_64-linux = self.bundlers.x86_64-linux.example;

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Provide inputs to modules
      specialArgs = { 
        from-flakes = {
          nix-inspect = inputs.nix-inspect.packages.x86_64-linux.default;
        };
      };
      modules = [
        ./configuration.nix

        sops-nix.nixosModules.sops

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jeff = import ./home.nix;   
        }
      ];
    };

    # Utilized by `nix develop .#<name>`
    devShells.x86_64-linux.example = self.devShell.x86_64-linux;

    # Utilized by `nix flake init -t <flake>#<name>`
    templates.example = self.defaultTemplate;
  };
}
