{ fetchurl, packer, writeShellScriptBin, writeTextFile, vagrant, flake }:
let
  iso = fetchurl {
    url = "https://releases.nixos.org/nixos/20.09/nixos-20.09.3341.df8e3bd1109/nixos-minimal-20.09.3341.df8e3bd1109-x86_64-linux.iso";
    sha256 = "sha256-aU4XtdOKzaAQRKB6509WejoirZcasd0O3KqRepgFyM8=";
  };
  builder = opts: {
    iso_url = iso;
    iso_checksum = "694e17b5d38acda01044a07ae74f567a3a22ad971ab1dd0edcaa917a9805c8cf";
    memory = "4096";
    disk_size = "50000";
    cpus = "4";
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
    headless = false;
    boot_wait = "5s";
    guest_os_type = "Linux_64";
  } // opts;
  packerConfig = {
    builders = [
      (builder {
        type = "virtualbox-iso";
        guest_additions_mode = "disable";
        format = "ova";
        vboxmanage = [["modifyvm" "{{ .Name }}" "--memory" "4096" "--vram" "128" "--clipboard" "bidirectional"]];
      })
      (builder {
        type = "vmware-iso";
        vmx_remove_ethernet_interfaces = true;
        guest_os_type = "Linux";
      })
      (builder {
        type = "qemu";
        boot_wait = "2m";
        disk_interface = "virtio-scsi";
        format = "qcow2";
        qemuargs = [ "-m" "4096" ];
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
      script = (toString ./install.sh);
    }
    ];
    post-processors = [{
      type = "vagrant";
      keep_input_artifact = false;
    }];
  };
in
writeShellScriptBin "packer-build-vmware-vagrant-box" ''
    ${packer}/bin/packer build -only vmware-iso ${writeTextFile { name = "packer-config"; text = (builtins.toJSON packerConfig); }}
''
