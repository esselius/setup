# nix-flakebox

## Build and upload box to vagrant cloud

```shell
$ nix run .#vmware
...
...
...
    vmware-iso (vagrant-cloud): this may take some time
    vmware-iso (vagrant-cloud): Uploading box
    vmware-iso (vagrant-cloud): Box successfully uploaded
==> vmware-iso (vagrant-cloud): Confirming direct box upload completion
==> vmware-iso (vagrant-cloud): Releasing version: 21.05
    vmware-iso (vagrant-cloud): Version successfully released and available
Build 'vmware-iso' finished after 8 minutes 18 seconds.

==> Wait completed after 8 minutes 18 seconds

==> Builds finished. The artifacts of successful builds are:
--> vmware-iso: 'vmware' provider box: nixos_vmware.box
--> vmware-iso: 'vmware_desktop': esselius/nixos
```