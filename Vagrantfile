# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :vmware_desktop do |v|
    v.gui = true
  end

  config.vm.define :nixos, primary: true do |nixos|
    nixos.vm.box = "nixos"

    nixos.vm.provision :shell,
        inline: "nixos-rebuild switch --flake /vagrant"
  end

  config.vm.define :ubuntu, autostart: false do |ubuntu|
    ubuntu.vm.box = "generic/ubuntu2004"
    ubuntu.vm.synced_folder ".", "/vagrant"

    ubuntu.vm.provision :shell,
        inline: "apt update && apt upgrade -y && apt install -y ubuntu-desktop i3"

    ubuntu.vm.provision :shell, privileged: false,
        inline: "sh <(curl -sSfL https://nixos.org/nix/install) --daemon --nix-extra-conf-file /vagrant/nix.conf"

    ubuntu.vm.provision :shell, privileged: false,
        inline: "nix run /vagrant#home-manager -- switch --flake /vagrant#vagrant"
  end

  config.vm.define :macos, autostart: false do |macos|
    macos.vm.box = "macos"
  end
end
