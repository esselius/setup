{ pkgs, lib, writeTextFile, writers, packer, vagrant, qemu }:

module:
let
  config = (lib.evalModules {
    modules = [{
      imports = [
        { _module.args = { inherit pkgs; }; }

        ./builders.nix
        ./provisioners.nix
        ./post-processors.nix

        module
      ];
    }];
  }).config;

  jsonConfig = writeTextFile { name = "packer-json-config"; text = builtins.toJSON config; };
in
writers.writeBashBin "packer-build" ''
  export PATH=${lib.makeBinPath [vagrant qemu]}
  ${packer}/bin/packer build ${jsonConfig}
''
