{ nixpkgs, darwin, dns-heaven, viscosity-sh, ... }:
let
  inherit (nixpkgs) lib;

  importModulesDir = dir:
    lib.fold lib.recursiveUpdate { } (map
      (path:
        lib.setAttrByPath
          (lib.pipe path [
            toString
            (lib.removePrefix "${toString dir}/")
            (lib.removeSuffix ".nix")
            (lib.strings.splitString "/")
          ])
          (import path))
      (lib.filesystem.listFilesRecursive dir));
in
{
  overlays = {
    packages = (final: prev: {
      dns-heaven = prev.callPackage ./pkgs/dns-heaven.nix { src = dns-heaven; };
      viscosity-sh = prev.callPackage ./pkgs/viscosity-sh.nix { src = viscosity-sh; };
    });
  };

  homeModules = importModulesDir ./home;
  darwinModules = importModulesDir ./darwin;
  nixosModules = importModulesDir ./nixos;
}
