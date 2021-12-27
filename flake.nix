{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    nixGL = { url = "github:guibou/nixGL"; flake = false; };
  };

  outputs = { self, nixpkgs, nixos, home-manager, flake-utils, nix-darwin, nixGL }@inputs:
    let
      inherit (nixos.lib) nixosSystem;
      inherit (nix-darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;

      overlays = [
        (import ./overlays/nixgl.nix inputs)
        (import ./overlays/open-vm-tools.nix)
      ];

      nixpkgsForSystem = { system, extraOverlays ? [ ] }@args: import nixpkgs (args // {
        overlays = overlays ++ extraOverlays;
        config.allowUnfree = true;
      });

      homeModules = {
        imports = [
          ./modules/home-asdf.nix
          ./modules/home-desktop.nix
          ./modules/home-gpg.nix
          ./modules/home-manual.nix
          ./modules/home-shell.nix
        ];
      };

      homeConfigModule = user: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${user} = homeModules;
        };
      };

      homeConfig = { username, system ? "x86_64-linux", homeDirectory ? "/home/${username}" }: homeManagerConfiguration {
        inherit system username homeDirectory;
        pkgs = nixpkgsForSystem { inherit system; extraOverlays = [ (final: prev: { isNixOS = false; }) ]; };
        configuration = homeModules;
      };

      nixosConfig = { system ? "x86_64-linux", modules ? [ ] }: nixosSystem {
        inherit system;
        modules = modules ++ [
          {
            nixpkgs = {
              pkgs = nixpkgsForSystem { inherit system; extraOverlays = [ (final: prev: { isNixOS = true; }) ]; };
            };
          }
          ./modules/nixos-nix.nix

          ./modules/nixos-hw-vmware-guest.nix
        ];
      };

      darwinConfig = user: darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./modules/darwin-homebrew.nix
          ./modules/darwin-gpg.nix
          ./modules/darwin-nix.nix

          home-manager.darwinModule
          (homeConfigModule user)
        ];
      };
    in
    {
      darwinConfigurations.vagrant = darwinConfig "packer";
      darwinConfigurations.Pepps-MacBook-Pro = darwinConfig "peteresselius";

      nixosConfigurations.packer = nixosConfig { };
      nixosConfigurations.vagrant = nixosConfig {
        modules = [
          ./modules/nixos-desktop.nix

          home-manager.nixosModule
          (homeConfigModule "vagrant")
        ];
      };

      homeConfigurations.vagrant = homeConfig { username = "vagrant"; };

      checks.x86_64-darwin.vagrant-macos = self.darwinConfigurations.vagrant.system;
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgsForSystem { inherit system; };
        packer = pkgs.callPackage ./packer { };

        vagrant-nixos = import ./packer/profiles/vagrant-nixos.nix;
      in
      {
        apps.darwin-rebuild = flake-utils.lib.mkApp { drv = pkgs.writers.writeBashBin "darwin-rebuild" ''${self.darwinConfigurations.vagrant.system}/sw/bin/darwin-rebuild "$@"''; };
        apps.home-manager = flake-utils.lib.mkApp { drv = pkgs.writers.writeBashBin "home-manager" ''${home-manager.defaultPackage.${system}}/bin/home-manager "$@"''; };
        apps.nixos-rebuild = flake-utils.lib.mkApp { drv = pkgs.writers.writeBashBin "nixos-rebuild" ''${pkgs.nixos-rebuild}/bin/nixos-rebuild "$@"''; };

        apps.packer-nixos = flake-utils.lib.mkApp { drv = packer vagrant-nixos; };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            rnix-lsp
          ];
        };
      }
    ));
}
