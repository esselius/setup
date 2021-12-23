{ lib, ... }:
let
  inherit (lib) mkOption filterAttrs;
  inherit (lib.types) nullOr listOf attrs enum submodule str;
in
{
  options.provisioners = mkOption {
    type = listOf (submodule {
      options = {
        type = mkOption { type = enum [ "shell" "file" ]; };
        execute_command = mkOption { type = nullOr str; default = null; };
        destination = mkOption { type = nullOr str; default = null; };
        source = mkOption { type = nullOr str; default = null; };
        inline = mkOption { type = nullOr (listOf str); default = null; };
        script = mkOption { type = nullOr str; default = null; };
      };
    });
    apply = map (filterAttrs (_: v: v != null));
  };
}
