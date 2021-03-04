#!/bin/sh -e

packer_http=$(cat .packer_http)

# Partition disk
cat <<FDISK | fdisk /dev/sda
n




a
w

FDISK

# Create filesystem
mkfs.ext4 -j -L nixos /dev/sda1

# Mount filesystem
mount LABEL=nixos /mnt

nix-channel --update

### Install ###
nix-env -iA nixos.nixFlakes

cd /mnt
nix --experimental-features "nix-command flakes" build /home/nixos/flake#nixosConfigurations.nixbox.config.system.build.toplevel --store /mnt --impure
nixos-install --system ./result --root /mnt
unlink result

### Cleanup ###
curl "$packer_http/postinstall.sh" | nixos-enter
