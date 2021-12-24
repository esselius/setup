{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos, home-manager, flake-utils, nix-darwin, nixGL }@inputs:
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

      commonVagrantHomeConfig = {
        manual.manpages.enable = false;

        programs.gpg = {
          enable = true;
        };
      };

      commonLinuxVagrantHomeConfig = commonVagrantHomeConfig // {
        services.gpg-agent.enable = true;

        xsession = {
          enable = true;
          windowManager.i3 = {
            enable = true;
            config = {
              modifier = "Mod4";
            };
          };
        };
      };

      ubuntuVagrantHomeConfig = { pkgs, ... }: commonLinuxVagrantHomeConfig // {
        xsession.windowManager.config.terminal = "${pkgs.wrapWithNixGLIntel pkgs.kitty}/bin/kitty";
      };
      nixosVagrantHomeConfig = { pkgs, ... }: commonLinuxVagrantHomeConfig // {
        xsession.windowManager.config.terminal = "${pkgs.kitty}/bin/kitty";
      };

      darwinVagrantHomeConfig = commonVagrantHomeConfig // { };
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

      darwinConfigurations.vagrant = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          home-manager.darwinModule

          {
            nix = {
              useDaemon = true;
              useSandbox = true;
              extraOptions = ''
                extra-experimental-features = nix-command flakes
              '';
            };
          }

          {
            homebrew = {
              enable = true;

              global = {
                noLock = true;
                brewfile = true;
              };
              cleanup = "zap";

              taps = [
                "homebrew/cask"
              ];

              casks = [
                "vmware-fusion"
                "vagrant-vmware-utility"
              ];
            };
          }

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.packer = darwinVagrantHomeConfig;
            };
          }

          {
            programs.gnupg.agent = {
              enable = true;
              enableSSHSupport = true;
            };
          }
        ];
      };
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgsForSystem system;
        packer = pkgs.callPackage ./packer { };

        vagrant-ubuntu = import ./packer/profiles/vagrant-ubuntu.nix;
        vagrant-nixos = import ./packer/profiles/vagrant-nixos.nix;
      in
      {
        apps.home-manager = home-manager.apps.${system}.home-manager;
        apps.darwin = flake-utils.lib.mkApp { drv = pkgs.writers.writeBashBin "darwin-rebuild" ''${self.darwinConfigurations.vagrant.system}/sw/bin/darwin-rebuild "$@"''; };
        apps.vagrantUbuntuBox = flake-utils.lib.mkApp { drv = packer vagrant-ubuntu; };
        apps.vagrantNixosBox = flake-utils.lib.mkApp { drv = packer vagrant-nixos; };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            rnix-lsp
          ];
        };
      }
    ));
}
