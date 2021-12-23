{ pkgs, lib, writeTextFile, writers, packer }:

module:
let
  config = (lib.evalModules {
    specialArgs = { inherit pkgs; };
    modules = [{
      imports = [
        ./builders.nix
        ./provisioners.nix
        ./post-processors.nix
        module
      ];
    }];
  }).config;

  jsonConfig = writeTextFile { name = "packer-json-config"; text = builtins.toJSON config; };
in
writers.writeBashBin "packer-build" "${packer}/bin/packer build ${jsonConfig}"
