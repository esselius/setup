{
  description = "Vagrant NixOS flake testing";

  outputs = { self, nixpkgs }: {
    overlay = final: prev: {
      vagrantBuildFlake = flake: prev.callPackage ./vagrantBuildFlake.nix { };
    };
  };
}
