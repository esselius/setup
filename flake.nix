{
  description = "Vagrant NixOS flake testing";

  outputs = { self, nixpkgs }: {
    lib = {
      vagrantBuildFlake = import ./vagrantBuildFlake.nix;
    };
  };
}
