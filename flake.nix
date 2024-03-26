{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs_rpi.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixGL = { url = "github:guibou/nixGL"; flake = false; };
    dns-heaven = { url = "github:jduepmeier/dns-heaven?rev=3a38e6cb0430753b579490b8bd4652e3fda5fc5d"; flake = false; };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nix-darwin, nixGL, dns-heaven, devenv, flake-parts, nixpkgs_rpi }@inputs:
    let
      nixpkgsConfig = { system }: {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./overlays/dns-heaven.nix inputs)
          (import ./overlays/devenv.nix inputs)
        ];
      };
      inherit (nix-darwin.lib) darwinSystem;
    in
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        flake =
          let
            nixpkgsModule = args: {
              nixpkgs = nixpkgsConfig args;
              nix.registry.nixpkgs.flake = nixpkgs;
            };

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

          };
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];
        perSystem = { config, system, pkgs, ... }:
          {
            apps.darwin-rebuild = flake-utils.lib.mkApp { drv = pkgs.writers.writeBashBin "darwin-rebuild" ''${(nix-darwin.lib.darwinSystem {modules = []; inherit system; }).system}/sw/bin/darwin-rebuild "$@"''; };
            apps.home-manager = flake-utils.lib.mkApp { drv = home-manager.defaultPackage.${system}; };
          };
      } // rec {
      nixosConfigurations.rpi = nixpkgs_rpi.lib.nixosSystem {
        modules = [
          "${nixpkgs_rpi}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
          "${nixpkgs_rpi}/nixos/modules/profiles/minimal.nix"
          ({ lib, pkgs, ... }: {
            nixpkgs.hostPlatform = { system = "armv6l-linux"; gcc = { arch = "armv6k"; fpu = "vfp"; }; };
            nixpkgs.buildPlatform.system = "aarch64-linux";

            system.stateVersion = "23.11";

            # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
            nixpkgs.overlays = [
              (final: super: {
                makeModulesClosure = x:
                  super.makeModulesClosure (x // { allowMissing = true; });
              })
            ];
            boot.supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];
            services.openssh.enable = true;
            security.sudo.wheelNeedsPassword = false;
            users.users.pepp = {
              uid = 1000;
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              password = "lol123";
            };
            networking.useDHCP = true;
            nix.settings.trusted-users = [ "root" "@wheel" ];
            services.mosquitto = {
              enable = true;
              listeners = [
                {
                  acl = [ "pattern readwrite #" ];
                  omitPasswordAuth = true;
                  settings.allow_anonymous = true;
                }
              ];
            };

            networking.firewall = {
              enable = true;
              allowedTCPPorts = [ 1883 ];
            };
            # services.step-ca = {
            #   enable = true;
            #   intermediatePasswordFile = "/run/keys/smallstep-password";
            # };
            # environment.defaultPackages = with pkgs; [
            #   step-ca
            #   step-cli
            #   # yubikey-manager
            # ];
          })
        ];
      };
      images.rpi = nixosConfigurations.rpi.config.system.build.sdImage;
    };
}
