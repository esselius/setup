{ fetchurl, packer, writeShellScriptBin, writeTextFile, symlinkJoin, writeShellScript }:

{ flake
, memory ? "4096"
, disk_size ? "50000"
, cpus ? "4"
, builder ? "vmware-iso"
, nixosConfig
, iso_url ? "https://releases.nixos.org/nixos/20.09/nixos-20.09.3341.df8e3bd1109/nixos-minimal-20.09.3341.df8e3bd1109-x86_64-linux.iso"
, iso_checksum ? "694e17b5d38acda01044a07ae74f567a3a22ad971ab1dd0edcaa917a9805c8cf"
}:
let
  installScript = writeTextFile {
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
      nix-env -iA nixos.nixFlakes
    
      nixos-install --flake /home/nixos/flake#${nixosConfig} --root /mnt --show-trace
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
  };

  builderConfig = opts: {
    inherit iso_url iso_checksum disk_size cpus memory;
    boot_command = [
      "<enter>"
      "<wait30s>"
      "echo http://{{ .HTTPIP }}:{{ .HTTPPort}} > .packer_http<enter>"
      "mkdir -m 0700 .ssh<enter>"
      "curl $(cat .packer_http)/install_rsa.pub > .ssh/authorized_keys<enter>"
      "sudo systemctl start sshd<enter>"
    ];
    http_directory = (toString ./.);
    shutdown_command = "sudo shutdown -h now";
    ssh_private_key_file = (toString ./install_rsa);
    ssh_port = 22;
    ssh_username = "nixos";
    ssh_agent_auth = false;
    headless = true;
    boot_wait = "5s";
    guest_os_type = "Linux_64";
  } // opts;

  packerConfig = {
    builders = [
      (builderConfig {
        type = "vmware-iso";
        vmx_remove_ethernet_interfaces = true;
        guest_os_type = "Linux";
      })
      (builderConfig {
        type = "virtualbox-iso";
        guest_additions_mode = "disable";
        format = "ova";
        vboxmanage = [ [ "modifyvm" "{{ .Name }}" "--memory" memory "--vram" "128" "--clipboard" "bidirectional" ] ];
      })
    ];
    provisioners = [
      {
        type = "file";
        source = flake;
        destination = "/home/nixos/flake";
      }
      {
        execute_command = "sudo su -c '{{ .Vars }} {{ .Path }}'";
        type = "shell";
        script = installScript;
      }
    ];
    post-processors = [{
      type = "vagrant";
      keep_input_artifact = false;
    }];
  };

  config = writeTextFile { name = "packer-config"; text = (builtins.toJSON packerConfig); };
in
writeShellScriptBin "packer-build" ''
  ${packer}/bin/packer build -only ${builder} ${config}
''
