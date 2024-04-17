{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs_rpi.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-rpi5.url = "gitlab:vriska/nix-rpi5";
    nix-rpi5.inputs.nixpkgs.follows = "nixpkgs";
    leo60228-nixpkgs.url = "github:leo60228/nixpkgs/linux_rpi5";

    nixGL = { url = "github:guibou/nixGL"; flake = false; };
    dns-heaven = { url = "github:jduepmeier/dns-heaven?rev=3a38e6cb0430753b579490b8bd4652e3fda5fc5d"; flake = false; };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nix-darwin, nixGL, dns-heaven, devenv, flake-parts, nixpkgs_rpi, nix-rpi5, leo60228-nixpkgs, nixos_unstable }@inputs:
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
      nixosConfigurations.vm-utm = nixpkgs.lib.nixosSystem {
        modules = [
          ({ modulesPath, ... }:
            {
              imports = [
                (modulesPath + "/profiles/qemu-guest.nix")
              ];

              boot.initrd.availableKernelModules = [ "xhci_pci" "uhci_hcd" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
              boot.initrd.kernelModules = [ ];
              boot.kernelModules = [ ];
              boot.extraModulePackages = [ ];

              fileSystems."/" =
                {
                  device = "/dev/disk/by-label/nixos";
                  fsType = "ext4";
                };

              fileSystems."/boot" =
                {
                  device = "/dev/disk/by-label/boot";
                  fsType = "vfat";
                };

              swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

              nixpkgs.hostPlatform = "aarch64-linux";
            })
          {
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;
            system.stateVersion = "23.11";
            networking.interfaces.enp0s1.useDHCP = true;
            services.spice-vdagentd.enable = true;
          }
        ];
      };
      nixosConfigurations.rpi5 = nixpkgs.lib.nixosSystem {
        modules = [
          # "${nixpkgs_rpi}/nixos/modules/installer/sd-card/sd-image.nix"
          # "${nixpkgs_rpi}/nixos/modules/profiles/base.nix"
          # ({ pkgs, config, lib, ... }: {
          #   nixpkgs.system = "aarch64-linux";
          #   # boot.kernelPackages = leo60228-nixpkgs.legacyPackages.aarch64-linux.linuxPackages_rpi5;
          #     boot.kernelPackages = (import (pkgs.fetchzip {url = "https://gitlab.com/vriska/nix-rpi5/-/archive/main.tar.gz"; sha256="sha256:12110c0sbycpr5sm0sqyb76aq214s2lyc0a5yiyjkjhrabghgdcb"; })).legacyPackages.aarch64-linux.linuxPackages_rpi5;
          #   # boot.kernelPackages = pkgs.linuxPackages_rpi4;
          #   # boot.supportedFilesystems.zfs = false;
          #   boot.supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];
          #   sdImage = {
          #     populateFirmwareCommands =
          #       let
          #         firmware = pkgs.callPackage ./pkgs/rpi5-uefi.nix { };
          #         raspberrypifw = nixos_unstable.legacyPackages.aarch64-linux.raspberrypifw;
          #       in
          #       ''
          #         (cd ${raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)

          #         cp ${pkgs.raspberrypi-armstubs}/armstub8-gic.bin firmware/armstub8-gic.bin
          #         cp ${raspberrypifw}/share/raspberrypi/boot/bcm2712-rpi-5-b.dtb firmware/

          #         cp ${firmware}/RPI_EFI.fd firmware/
          #         cp ${firmware}/config.txt firmware/
          #       '';
          #     populateRootCommands = ''
          #       mkdir -p ./files/boot
          #       ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
          #     '';
          #   };
          #   boot.loader.grub.device = "nodev";
          #   boot.loader.grub.efiSupport = true;
          #   boot.loader.grub.enable = false;
          #   boot.loader.generic-extlinux-compatible.enable = true;

          #   boot.consoleLogLevel = lib.mkDefault 7;

          #   # The serial ports listed here are:
          #   # - ttyS0: for Tegra (Jetson TX1)
          #   # - ttyAMA0: for QEMU's -machine virt
          #   boot.kernelParams = [ "console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0" ];

          #   # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
          #   nixpkgs.overlays = [
          #     (final: super: {
          #       makeModulesClosure = x:
          #         super.makeModulesClosure (x // { allowMissing = true; });
          #     })
          #   ];
          # })
          ./rpi5/configuration.nix
          {
            boot.kernelPackages = leo60228-nixpkgs.legacyPackages.aarch64-linux.linuxPackages_rpi5;
          }
        ];
      };
      # nixosConfigurations.rpi = nixpkgs_rpi.lib.nixosSystem {
      #   modules = [
      #     "${nixpkgs_rpi}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
      #     "${nixpkgs_rpi}/nixos/modules/profiles/minimal.nix"
      #     ({ lib, pkgs, ... }: {
      #       nixpkgs.hostPlatform = {
      #         system = "armv6l-linux";
      #         gcc = {
      #           arch = "armv6k";
      #           fpu = "vfp";
      #         };
      #         fpu = "vfp";
      #       };
      #       nixpkgs.buildPlatform.system = "aarch64-linux";

      #       system.stateVersion = "23.11";

      #       # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
      #       nixpkgs.overlays = [
      #         (final: super: {
      #           makeModulesClosure = x:
      #             super.makeModulesClosure (x // { allowMissing = true; });
      #         })
      #       ];
      #       boot.supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];
      #       services.openssh.enable = true;
      #       security.sudo.wheelNeedsPassword = false;
      #       users.users.pepp = {
      #         uid = 1000;
      #         isNormalUser = true;
      #         extraGroups = [ "wheel" ];
      #         password = "lol123";
      #       };
      #       networking.useDHCP = true;
      #       nix.settings.trusted-users = [ "root" "@wheel" ];
      #       services.mosquitto = {
      #         enable = true;
      #         listeners = [
      #           {
      #             acl = [ "pattern readwrite #" ];
      #             omitPasswordAuth = true;
      #             settings.allow_anonymous = true;
      #           }
      #         ];
      #       };

      #       networking.firewall = {
      #         enable = true;
      #         allowedTCPPorts = [ 1883 5201 ];
      #       };
      #       # services.step-ca = {
      #       #   enable = true;
      #       #   intermediatePasswordFile = "/run/keys/smallstep-password";
      #       # };
      #       environment.defaultPackages = with pkgs; [
      #         # step-ca
      #         step-cli
      #         go
      #         # yubikey-manager
      #         # iperf3
      #         # binutils-unwrapped
      #       ];
      #     })
      #   ];
      # };
      # images.rpi = nixosConfigurations.rpi.config.system.build.sdImage;
      # images.rpi5 = nixosConfigurations.rpi5.config.system.build.sdImage;
    };
}
