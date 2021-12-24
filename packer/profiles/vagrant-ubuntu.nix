{
  builders = [{
    communicator = "ssh";
    source_path = "generic/ubuntu2004";
    provider = "vmware_desktop";
    type = "vagrant";
  }];
  provisioners = [
    {
      type = "file";
      source = toString ./../..;
      destination = "/home/vagrant/setup";
    }

    {
      type = "shell";
      execute_command = "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'";
      inline = [
        "apt update"
        "apt upgrade -y"
        "apt install -y ubuntu-desktop"
      ];
    }

    {
      type = "shell";
      inline = [
        "curl -sSfL https://nixos.org/nix/install | sh -s -- --daemon --nix-extra-conf-file /home/vagrant/setup/nix.conf"
      ];
    }
  ];
}
