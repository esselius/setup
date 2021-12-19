{
  description = "Vagrant NixOS flake testing";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-21.05";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-darwin";
      };

      packerBuild = pkgs.callPackage ./packerBuild.nix { };

      vagrantNixosConfig = { system ? "x86_64-linux", provider, modules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            {
              nixpkgs.overlays = [
                (final: prev: {
                  open-vm-tools = prev.open-vm-tools.overrideAttrs (old: {
                    postPatch = old.postPatch + ''
                      sed -i 's,/usr/bin/,/run/current-system/sw/bin/,g' services/plugins/vix/foundryToolsDaemon.c 
                      sed -i 's,/usr/bin/,/run/current-system/sw/bin/,g' vmhgfs-fuse/config.c
                    '';
                  });
                })
              ];
            }
            ./modules/bootloader.nix
            ./modules/hardware.nix
            ./modules/services.nix
            ./modules/user.nix
            ./modules/nixUnstable.nix
            (./modules/providers + "/${provider}.nix")
          ] ++ modules;
        };

      vagrantCloudBox = "esselius/nixos";
      version = "21.05";
      iso_url = "https://channels.nixos.org/nixos-${version}/latest-nixos-minimal-x86_64-linux.iso";
      iso_checksum = "1150b7dada3a6a945dbf1901ca176c7cdd3914b5f643ececc2fd823507ff5f31";
    in
    {
      apps.x86_64-darwin.vmware = {
        type = "app";
        program = "${packerBuild { inherit vagrantCloudBox version iso_url iso_checksum; flake = self; nixosConfig = "vmwareBase"; builder = "vmware-iso";  }}/bin/packer-build";
      };

      apps.x86_64-darwin.virtualbox = {
        type = "app";
        program = "${packerBuild { inherit vagrantCloudBox version iso_url iso_checksum;flake = self; nixosConfig = "virtualboxBase"; builder = "virtualbox-iso"; }}/bin/packer-build";
      };

      devShell.x86_64-darwin = pkgs.mkShell { buildInputs = [ pkgs.vagrant ]; };

      lib = {
        inherit packerBuild vagrantNixosConfig;
      };

      nixosConfigurations = rec {
        vmwareBase = vagrantNixosConfig { provider = "vmware"; };

        virtualboxBase = vagrantNixosConfig { provider = "virtualbox"; };
      };
    };
}
