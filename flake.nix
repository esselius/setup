{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    nixGL = { url = "github:guibou/nixGL"; flake = false; };
    dns-heaven = { url = "github:jduepmeier/dns-heaven?rev=3a38e6cb0430753b579490b8bd4652e3fda5fc5d"; flake = false; };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nix-darwin, nixGL, dns-heaven, devenv }@inputs:
    let
      inherit (nix-darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;

      nixpkgsConfig = { system }: {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./overlays/dns-heaven.nix inputs)
          (import ./overlays/devenv.nix inputs)
        ];
      };

      nixpkgsModule = args: {
        nixpkgs = nixpkgsConfig args;
        nix.registry.nixpkgs.flake = nixpkgs;
      };

      nixpkgsForSystem = args: import nixpkgs (nixpkgsConfig args);

      homeModules = {
        imports = [
          ./modules/home-asdf.nix
          ./modules/home-base.nix
          ./modules/home-desktop.nix
          ./modules/home-git.nix
          ./modules/home-manual.nix
          ./modules/home-packages.nix
          ./modules/home-shell.nix
        ];
      };

      homeConfigModule = { user }: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          users.${user} = homeModules;
        };
      };

      homeConfig = { username, system, homeDirectory }: homeManagerConfiguration {
        inherit system username homeDirectory;
        pkgs = nixpkgsForSystem { inherit system; };
        configuration = homeModules;
      };

      darwinConfig = { system, user }: darwinSystem {
        inherit system inputs;
        modules = [
          (nixpkgsModule { inherit system; })

          ./modules/darwin-desktop.nix
          ./modules/darwin-dns-heaven.nix
          ./modules/darwin-homebrew.nix
          ./modules/darwin-nix.nix
          ./modules/darwin-shell.nix
          ./modules/darwin-vpn.nix

          (import ./modules/darwin-user.nix user)
          home-manager.darwinModule
          (homeConfigModule { user = user; })
        ];
      };
    in
    {
      darwinConfigurations.Pepps-MacBook-Pro = darwinConfig { system = "x86_64-darwin"; user = "peteresselius"; };
      darwinConfigurations.Fox = darwinConfig { system = "aarch64-darwin"; user = "peteresselius"; };
      darwinConfigurations.Petere-MBP = darwinConfig { system = "aarch64-darwin"; user = "peteresselius"; };

    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgsForSystem { inherit system; };
      in
      {
        apps.darwin-rebuild = flake-utils.lib.mkApp { drv = pkgs.writers.writeBashBin "darwin-rebuild" ''${(nix-darwin.lib.darwinSystem {modules = []; inherit system; }).system}/sw/bin/darwin-rebuild "$@"''; };
        apps.home-manager = flake-utils.lib.mkApp { drv = home-manager.defaultPackage.${system}; };
      }
    ));
}
