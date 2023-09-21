{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
 
  };

  outputs = inputs @ { self, nixpkgs, hyprland, home-manager }: 
    let
      system = "x86_64-linux";
      user = "mehran";
    in {

      nixosConfigurations.mehran-rog = nixpkgs.lib.nixosSystem rec{
        inherit system;
        specialArgs = {inherit hyprland user; };
        modules = [ 
          ./outputs/configuration.nix
          hyprland.nixosModules.default 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home/home.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };
}
