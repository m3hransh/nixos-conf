{
  description = "My NixOS configuration";

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let

      pkgs = import nixpkgs {
        system = settings.systemS.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      settings = {
        # these attrs contains all user's ans system's settings
        # it will passed to all modules
        inherit (builtins.fromTOML (builtins.readFile ./settings.toml)) systemS userS ubuntu;

        # helper function to get package from nixpkgs
        # this help with cases like package = pkg.subpkg
        getPack = p: pkgs:
          (
            let
              splited = inputs.nixpkgs.lib.strings.splitString "." p;
            in
            inputs.nixpkgs.lib.attrsets.getAttrFromPath splited pkgs
          );
      };

      lib = inputs.nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        system = lib.nixosSystem {
          system = settings.systemS.system;
          modules = [
            ./system/configuration.nix
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            # pass config variables from above
            # inherit pkgs-stable;
            inherit settings;
            inherit inputs;
          };
        };
      };

      homeConfigurations.${settings.userS.user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home/home.nix ];

        # Optionally use extraSpecialArgs
        extraSpecialArgs = { inherit settings inputs; };
        # to pass through arguments to home.nix
      };
      homeConfigurations.ubuntu = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./ubuntu/home.nix ];

        # Optionally use extraSpecialArgs
        extraSpecialArgs = { inherit settings inputs; };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    #home-manager.url = "github:nix-community/home-manager/master"; 
    nix-gaming.url = "github:fufexan/nix-gaming";
    # Specify the source of Home Manager and Nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland = {
    #   url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # };

    hyprpicker.url = "github:hyprwm/hyprpicker";
    hypr-contrib.url = "github:hyprwm/contrib";
    stylix.url = "github:danth/stylix/release-25.05";
  };

}
