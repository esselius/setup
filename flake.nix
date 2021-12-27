{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    nixGL = { url = "github:guibou/nixGL"; flake = false; };
    dns-heaven = { url = "github:jduepmeier/dns-heaven?rev=3a38e6cb0430753b579490b8bd4652e3fda5fc5d"; flake = false; };
  };

  outputs = { self, nixpkgs, nixos, home-manager, flake-utils, nix-darwin, nixGL, dns-heaven }@inputs:
    let
      inherit (nixos.lib) nixosSystem;
      inherit (nix-darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;

      nixpkgsConfig = { system, isNixOS ? false }: {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./overlays/nixgl.nix inputs)
          (import ./overlays/dns-heaven.nix inputs)
          (import ./overlays/open-vm-tools.nix)
          (final: prev: { inherit isNixOS; })
        ];
      };

      nixpkgsForSystem = args: import nixpkgs (nixpkgsConfig args);

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
        pkgs = nixpkgsForSystem { inherit system; };
        configuration = homeModules;
      };

      nixosConfig = { system ? "x86_64-linux", modules ? [ ] }: nixosSystem {
        inherit system;
        modules = modules ++ [
          { nixpkgs = nixpkgsConfig { inherit system; isNixOS = true; }; }

          ./modules/nixos-nix.nix
          ./modules/nixos-hw-vmware-guest.nix
        ];
      };

      darwinConfig = system: user: darwinSystem {
        inherit system;
        modules = [
          { nixpkgs = nixpkgsConfig { inherit system; }; }

          ./modules/darwin-homebrew.nix
          ./modules/darwin-gpg.nix
          ./modules/darwin-nix.nix
          ./modules/darwin-desktop.nix
          ./modules/darwin-dns-heaven.nix
          ./modules/darwin-vpn.nix

          home-manager.darwinModule
          (homeConfigModule user)
        ];
      };
    in
    {
      darwinConfigurations.vagrant = darwinConfig "x86_64-darwin" "packer";
      darwinConfigurations.Pepps-MacBook-Pro = darwinConfig "x86_64-darwin" "peteresselius";

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
