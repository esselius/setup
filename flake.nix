{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";

    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos, home-manager, flake-utils, nixGL }@inputs:
    with builtins;
    let
      inherit (nixpkgs) lib;

      nixGLOverlay = final: prev:
        let
          nixGL = import inputs.nixGL { pkgs = final; };
          wrapWithNixGL = wrapper: package:
            let
              getBinFiles = pkg:
                lib.pipe "${lib.getBin pkg}/bin" [
                  readDir
                  attrNames
                  (filter (n: match "^\\..*" n == null))
                ];

              wrapperBin = lib.pipe wrapper [
                getBinFiles
                (filter (n: n == (lib.getName wrapper)))
                head
                (x: "${wrapper}/bin/${x}")
              ];

              binFiles = getBinFiles package;
              wrapBin = name:
                final.writeShellScriptBin name ''
                  exec ${wrapperBin} ${package}/bin/${name} "$@"
                '';
            in
            final.symlinkJoin {
              name = "${package.name}-nixgl";
              paths = (map wrapBin binFiles) ++ [ package ];
            };

          wrappers =
            let
              replacePrefix =
                replaceStrings [ "wrapWithNixGL" ] [ "nixGL" ];
            in
            lib.genAttrs [
              "wrapWithNixGLNvidia"
              "wrapWithNixGLIntel"
              "wrapWithNixGLDefault"
            ]
              (name: wrapWithNixGL final.${replacePrefix name});
        in
        {
          inherit (nixGL) nixGLNvidia nixGLIntel nixGLDefault;
          inherit wrapWithNixGL;
        } // wrappers;

      openVmToolsOverlay = final: prev: {
        open-vm-tools = prev.open-vm-tools.overrideAttrs (old: {
          postPatch = old.postPatch + ''
            sed -i 's,/usr/bin/,/run/current-system/sw/bin/,g' services/plugins/vix/foundryToolsDaemon.c
            sed -i 's,/usr/bin/,/run/current-system/sw/bin/,g' vmhgfs-fuse/config.c
          '';
        });
      };

      overlays = [
        nixGLOverlay
        openVmToolsOverlay
      ];

      nixpkgsForSystem = system: import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      vagrantHomeConfig = { pkgs, ... }: {
        manual.manpages.enable = false;

        xsession = {
          enable = true;
          windowManager.i3 = {
            enable = true;
            config = {
              modifier = "Mod4";
              # terminal = "${pkgs.wrapWithNixGLIntel pkgs.kitty}/bin/kitty";
              terminal = "${pkgs.kitty}/bin/kitty";
            };
          };
        };
      };
    in
    {
      nixosConfigurations.vagrant = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs = { inherit overlays; }; }

          {
            boot.loader.grub.enable = true;
            boot.loader.grub.version = 2;
            boot.loader.grub.device = "/dev/sda";
            boot.loader.timeout = 1;
            boot.initrd.checkJournalingFS = false;
          }

          {
            boot.initrd.availableKernelModules = [
              "ata_piix"
              "mptspi"
              "sd_mod"
              "sr_mod"
              "mptspi"
              "vmw_balloon"
              "vmwgfx"
              "vmw_vmci"
              "vmw_vsock_vmci_transport"
              "vmxnet3"
              "vsock"
            ];

            fileSystems."/" = {
              device = "/dev/disk/by-label/nixos";
              fsType = "ext4";
            };
          }

          ({ modulesPath, ... }: {
            imports = [
              "${modulesPath}/virtualisation/vagrant-guest.nix"
            ];
          })
          {
            virtualisation.vmware.guest.enable = true;
          }

          {
            nix = {
              extraOptions = ''
                experimental-features = nix-command
                extra-experimental-features = flakes
              '';
            };
          }

          {
            services.xserver = {
              enable = true;
              layout = "us";

              displayManager = {
                defaultSession = "none+i3";
                lightdm.enable = true;
              };

              windowManager = {
                i3.enable = true;
              };
            };
          }

          ({ pkgs, ... }: { environment.systemPackages = [ pkgs.git ]; })

          home-manager.nixosModule

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.vagrant = vagrantHomeConfig;
            };
          }
        ];
      };

      homeConfigurations.vagrant = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        pkgs = nixpkgsForSystem "x86_64-linux";
        homeDirectory = "/home/vagrant";
        username = "vagrant";
        configuration.imports = [ vagrantHomeConfig ];
      };

    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgsForSystem system;
        packer = pkgs.callPackage ./lib/packer.nix { };
        packer2 = pkgs.callPackage ./packer { };

        vagrant-ubuntu = import ./packer/profiles/vagrant-ubuntu.nix;
        vagrant-nixos = import ./packer/profiles/vagrant-nixos.nix;
      in
      {
        apps.home-manager = home-manager.apps.${system}.home-manager;
        apps.packer2 = flake-utils.lib.mkApp { drv = packer2 vagrant-ubuntu; };
        apps.packer3 = flake-utils.lib.mkApp { drv = packer2 vagrant-nixos; };

        packages.nixosVagrantBox = packer {
          nixosConfig = "nixos";
          flake = self;
          builder = "vmware-iso";
          iso_url = "https://releases.nixos.org/nixos/unstable-small/nixos-22.05pre339321.42c2003e5a0/nixos-minimal-22.05pre339321.42c2003e5a0-x86_64-linux.iso";
          iso_checksum = "40e06d5a39f17e83ff44507a69091f7dd7853ecc200f0c581efd9277d97390ba";
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            rnix-lsp
          ];
        };
      }
    ));
}
