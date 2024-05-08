{
  description = "My NixOS configuration";

  outputs = inputs @ { self, nixpkgs, home-manager, nixpkgs-stable }:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostName = "mehran-rog";
        gnome = "enabled";
      };

      userSettings = {
        user = "mehran";
        name = "Mehran";
        email = "";
        nixDir = "/home/mehran/.nixconf";
        wm = "gnome";
        font = "Intel One Mono";
        fontPkg = pkgs.intel-one-mono;
        editor = "nvim";
      };

      pkgs = import nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      lib = inputs.nixpkgs.lib;
    in
    {

      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            ./system/configuration.nix
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            # pass config variables from above
            # inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      homeConfigurations.${userSettings.user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home/home.nix ];

        # Optionally use extraSpecialArgs
        extraSpecialArgs = { inherit userSettings systemSettings inputs; };
        # to pass through arguments to home.nix
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    #home-manager.url = "github:nix-community/home-manager/master"; 
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Specify the source of Home Manager and Nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

}
