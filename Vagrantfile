# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.forward_agent = true

  config.vm.provider :vmware_desktop do |v|
    v.gui = true
  end

  config.vm.define :nixos, primary: true do |nixos|
    nixos.vm.disk :disk, size: "100GB", primary: true

    nixos.vm.box = "nixos"

    config.vm.provider :vmware_desktop do |v|
      v.vmx["numvcpus"] = "4"
      v.vmx["memsize"] = "8192"

      # Enable USB controller
      v.vmx["usb.present"] = "TRUE"

      # Use yubikey inside VM, in 2 modes:
      #
      # 1. Yubikey -> virtual smartcard @ VM
      # Enables yubikey PIV to be used by both host and guest OS's
      # v.vmx["usb.autoConnect.device0"] = "deviceType:virtual-smartcard"
      #
      # 2. Raw YubiKey passthrough
      # Enables yubikey PIV admin and enables other non-PIV features, like U2F/FIDO2
      v.vmx["usb.generic.allowCCID"] = "TRUE"
      v.vmx["usb.generic.allowHID"] = "TRUE"
      v.vmx["usb.generic.allowLastHID"] = "TRUE"
    end

    nixos.vm.provision :shell, privileged: false,
      inline: "sudo nix run /vagrant#nixos-rebuild -- switch --flake /vagrant#vagrant"

    nixos.vm.provision :shell, reboot: true
  end

  config.vm.define :ubuntu, autostart: false do |ubuntu|
    ubuntu.vm.box = "generic/ubuntu2004"
    ubuntu.vm.synced_folder ".", "/vagrant"

    ubuntu.vm.provision :shell,
        inline: "apt update && apt upgrade -y && env DEBIAN_FRONTEND=noninteractive apt install -y lightdm i3"

    ubuntu.vm.provision :shell, privileged: false,
        inline: "curl -sSfL https://nixos.org/nix/install | sh -s -- --daemon --nix-extra-conf-file /vagrant/nix.conf"

    ubuntu.vm.provision :shell, privileged: false,
        inline: "nix run /vagrant#home-manager -- switch --flake /vagrant#vagrant"

    ubuntu.vm.provision :shell, privileged: false,
        inline: "which fish | sudo tee -a /etc/shells"

    ubuntu.vm.provision :shell, privileged: false,
        inline: "sudo chsh -s $(which fish) vagrant"

    ubuntu.vm.provision :shell, reboot: true
  end

  config.vm.define :macos, autostart: false do |macos|
    macos.vm.box = "macos"

    macos.vm.synced_folder ".", "/vagrant", disabled: true

    macos.ssh.username = "packer"
    macos.ssh.password = "packer"

    macos.vm.provider :vmware_desktop do |v|
      v.vmx["numvcpus"] = "4"
    end
  end
end
