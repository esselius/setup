{
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "mptspi"
    "sd_mod"
    "sr_mod"
    "mptspi"
    "vmw_balloon"
    "vmwgfx"
    "vmw_vmci"
    "vmw_vsock_vmci_transport"
    "vmxnet3"
    "vsock"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
