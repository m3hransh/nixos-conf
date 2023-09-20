{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 
  };

  outputs = inputs @ { self, nixpkgs, home-manager }: 
    let
      system = "x86_64-linux";
    in {

      nixosConfigurations.mehran-rog = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          ./outputs/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mehran = import ./home/home.nix;
          }
        ];
      };
    };
}
