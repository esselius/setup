{ lib, ... }:
let
  inherit (lib) mkOption filterAttrs;
  inherit (lib.types) nullOr listOf attrs submodule str enum int bool;
in
{
  options.builders = mkOption {
    type = nullOr (listOf (submodule {
      options = {
        type = mkOption { type = enum [ "vagrant" "vmware-iso" ]; };
        communicator = mkOption { type = enum [ null "ssh" ]; default = null; };
        provider = mkOption { type = enum [ null "vmware_desktop" ]; default = null; };
        source_path = mkOption { type = nullOr str; default = null; };
        boot_command = mkOption { type = nullOr (listOf str); default = null; };
        boot_wait = mkOption { type = nullOr str; default = null; };
        cpus = mkOption { type = nullOr int; default = null; };
        disk_size = mkOption { type = nullOr int; default = null; };
        guest_os_type = mkOption { type = nullOr str; default = null; };
        headless = mkOption { type = nullOr bool; default = null; };
        http_directory = mkOption { type = nullOr str; default = null; };
        iso_checksum = mkOption { type = nullOr str; default = null; };
        iso_url = mkOption { type = nullOr str; default = null; };
        memory = mkOption { type = nullOr int; default = null; };
        shutdown_command = mkOption { type = nullOr str; default = null; };
        ssh_agent_auth = mkOption { type = nullOr bool; default = null; };
        ssh_private_key_file = mkOption { type = nullOr str; default = null; };
        ssh_username = mkOption { type = nullOr str; default = null; };
        vmx_remove_ethernet_interfaces = mkOption { type = nullOr bool; default = null; };
      };
    }));
    apply = map (filterAttrs (_: v: v != null));
  };
}
