{ fetchurl, packer, writeShellScriptBin, writeTextFile, vagrant }:
let
  iso = fetchurl {
    url = "https://releases.nixos.org/nixos/20.09/nixos-20.09.3341.df8e3bd1109/nixos-minimal-20.09.3341.df8e3bd1109-x86_64-linux.iso";
    sha256 = "sha256-aU4XtdOKzaAQRKB6509WejoirZcasd0O3KqRepgFyM8=";
  };
  builder = opts: {
    iso_url = iso;
    iso_checksum = "694e17b5d38acda01044a07ae74f567a3a22ad971ab1dd0edcaa917a9805c8cf";
    memory = "1024";
    disk_size = "20480";
    boot_wait = "5s";
    boot_command = [
      "<enter>"
      "<wait20s>"
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
    headless = true;
  };
  packerConfig = {
    builders = [
      (builder {
        type = "vmware-iso";
        guest_os_type = "Linux";
        vmx_remove_ethernet_interfaces = true;
      })
      (builder {
        type = "qemu";
        guest_os_type = "Linux";
        disk_interface = "virtio-scsi";
        format = "qcow2";
        qemuargs = [ "-m" "1024" ];
      })
    ];
    provisioners = [{
      execute_command = "sudo su -c '{{ .Vars }} {{ .Path }}'";
      type = "shell";
      script = (toString ./install.sh);
    }];
    post-processors = [{
      type = "vagrant";
      keep_input_artifact = false;
    }];
  };
in
writeShellScriptBin "packer-build-vmware-vagrant-box" ''
    ${packer}/bin/packer build ${writeTextFile { name = "packer-config"; text = (builtins.toJSON packerConfig); }}
''
