{ pkgs, ... }:
{
  builders = [{
    iso_url = "https://releases.nixos.org/nixos/unstable-small/nixos-22.05pre339321.42c2003e5a0/nixos-minimal-22.05pre339321.42c2003e5a0-x86_64-linux.iso";
    iso_checksum = "40e06d5a39f17e83ff44507a69091f7dd7853ecc200f0c581efd9277d97390ba";
    disk_size = 50000;
    cpus = 4;
    memory = 4096;
    boot_command = [
      "<enter>"
      "<wait30s>"
      "echo http://{{ .HTTPIP }}:{{ .HTTPPort }} > .packer_http<enter>"
      "mkdir -m 0700 .ssh<enter>"
      "curl $(cat .packer_http)/install_ssh_key.pub > .ssh/authorized_keys<enter>"
      "sudo systemctl start sshd<enter>"
    ];
    http_directory = (toString ./../../lib);
    shutdown_command = "sudo shutdown -h now";
    ssh_private_key_file = (toString ./../../lib/install_ssh_key);
    ssh_username = "nixos";
    ssh_agent_auth = false;
    headless = false;
    boot_wait = "5s";
    type = "vmware-iso";
    vmx_remove_ethernet_interfaces = true;
    guest_os_type = "Linux";
  }];
  provisioners = [
    {
      type = "file";
      source = toString ./../..;
      destination = "/home/nixos/flake";
    }
    {
      execute_command = "sudo su -c '{{ .Vars }} {{ .Path }}'";
      type = "shell";
      script = toString (pkgs.writeTextFile {
        name = "install";
        text = ''
          #!/bin/sh
          set -euo pipefail

          cat <<EOF | fdisk /dev/sda
          n




          a
          w

          EOF

          mkfs.ext4 -j -L nixos /dev/sda1
          mount LABEL=nixos /mnt

          nix-channel --update

          nixos-install --flake /home/nixos/flake#vagrant --root /mnt --show-trace

          nixos-enter <<EOF
          #!/bin/sh
          set -euo pipefail
          nix-env --delete-generations old
          nix-collect-garbage -d
          rm -rf /root/.ssh /root/.packer_http
          dd if=/dev/zero of=/EMPTY bs=1M || true
          rm -rf /EMPTY
          EOF
        '';
      });
    }
  ];
  post-processors = [{
    type = "vagrant";
    output = "nixos_{{.Provider}}.box";
  }];
}
