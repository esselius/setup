{
  description = "My darwin system";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    darwin.url       = "github:lnl7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs, home-manager }@inputs: {
    darwinConfigurations."Vagrants-MacBook-Pro" = darwin.lib.darwinSystem {
      modules = [
        ./darwin-configuration.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vagrant = import ./home.nix;
        }
      ];
    };
  };
}