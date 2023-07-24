{
  description = "A template that shows all standard flake outputs";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

  # The nixpkgs entry in the flake registry.
  inputs.nixpkgsRegistry.url = "nixpkgs";

  # to be equal to the nixpkgs input of the nixops input of the top-level flake:
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.nix-bundle.url = "github:NixOS/bundlers";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = all@{ self, nixpkgs, home-manager, nix-bundle, ... }: {

    # Utilized by `nix bundle -- .#<name>` (should be a .drv input, not program path?)
    bundlers.x86_64-linux.example = nix-bundle.bundlers.x86_64-linux.toArx;

    # Utilized by `nix bundle -- .#<name>`
    defaultBundler.x86_64-linux = self.bundlers.x86_64-linux.example;

    # Default overlay, for use in dependent flakes
    overlay = final: prev: { };

    # # Same idea as overlay but a list or attrset of them.
    overlays = { exampleOverlay = self.overlay; };

    # Default module, for use in dependent flakes
    nixosModule = { config, ... }: { options = {}; config = {}; };

    # Same idea as nixosModule but a list or attrset of them.
    nixosModules = { exampleModule = self.nixosModule; };

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

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
