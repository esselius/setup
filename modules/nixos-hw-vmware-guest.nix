{ modulesPath, ... }: {
  imports = [
    "${modulesPath}/virtualisation/vagrant-guest.nix"
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        version = 2;
      };
      timeout = 1;
    };
    initrd = {
      availableKernelModules = [
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
      checkJournalingFS = false;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  virtualisation.vmware.guest.enable = true;
}
