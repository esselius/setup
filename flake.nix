{
  description = "Nix Config of Pepp";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, darwin, home }:
    let
      darwinConfig = username: darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
          home.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    in
    {
      darwinConfigurations = {
        Pepps-MacBook-Pro    = darwinConfig "peteresselius";
        Vagrants-MacBook-Pro = darwinConfig "vagrant";
      };

      packages.x86_64-darwin.nix-darwin-installer = self.darwinConfigurations.Pepps-MacBook-Pro.system;
    };
}