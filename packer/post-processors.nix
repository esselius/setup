{ lib, ... }:
let
  inherit (lib) mkOption filterAttrs;
  inherit (lib.types) nullOr listOf attrs enum submodule str;
in
{
  options.post-processors = mkOption {
    default = [ ];
    type = listOf (submodule {
      options = {
        type = mkOption { type = enum [ "vagrant" ]; };
        output = mkOption { type = nullOr str; default = null; };
      };
    });
    apply = map (filterAttrs (_: v: v != null));
  };
}
