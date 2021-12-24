# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :vmware_desktop do |v|
    v.gui = true
  end

  config.vm.define :nixos, primary: true do |nixos|
    nixos.vm.box = "nixos"
  end

  config.vm.define :ubuntu, autostart: false do |ubuntu|
    ubuntu.vm.box = "generic/ubuntu2004"
    ubuntu.vm.synced_folder ".", "/vagrant"
  end

  config.vm.define :macos, autostart: false do |macos|
    macos.vm.box = "macos"
  end
end
