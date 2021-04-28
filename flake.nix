{
  description = "Vagrant NixOS flake testing";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-darwin";
      };

      packerBuild = pkgs.callPackage ./packerBuild.nix { };

      vagrantNixosConfig = system: provider: modules: nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./modules/bootloader.nix
          ./modules/hardware.nix
          ./modules/packages.nix
          ./modules/services.nix
          ./modules/user.nix
          (./modules/providers + "/${provider}.nix")
        ] ++ modules;
      };
    in
    {
      apps.x86_64-darwin.vmware = {
        type = "app";
        program = "${packerBuild { flake = self; }}/bin/packer-build";
      };

      apps.x86_64-darwin.virtualbox = {
        type = "app";
        program = "${packerBuild { flake = self; nixosConfig = "virtualboxBase"; builder = "virtualbox-iso"; }}/bin/packer-build";
      };

      lib = {
        inherit packerBuild vagrantNixosConfig;
      };

      nixosConfigurations = rec {
        vmwareBase = vagrantNixosConfig "x86_64-linux" "vmware" [ ];
        virtualboxBase = vagrantNixosConfig "x86_64-linux" "virtualbox" [ ];
      };
    };
}


