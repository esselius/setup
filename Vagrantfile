Vagrant.configure("2") do |config|
  config.vm.define :mac do |mac|
    # https://app.vagrantup.com/ramsey/boxes/macos-catalina
    mac.vm.box = "ramsey/macos-catalina"

    mac.vm.synced_folder ".", "/Users/vagrant/nix-config", type: "rsync"

    mac.vm.provision :shell, privileged: false, inline: "cd nix-config && ./mac/provision.sh"
  end

  config.vm.define :linux do |linux|
    # https://app.vagrantup.com/ubuntu/boxes/focal64
    linux.vm.box = "ubuntu/focal64"

    linux.vm.provider :virtualbox do |v|
      v.memory = 4096
    end

    linux.vm.provision :shell, privileged: false, inline: "cd /vagrant && ./linux/provision.sh"
  end

  config.vm.define :win do |win|
    # https://app.vagrantup.com/gusztavvargadr/boxes/windows-10/
    win.vm.box = "gusztavvargadr/windows-10"

    win.vm.provider :virtualbox do |v|
      v.memory = 4096

      v.gui = true

      # WSL 2 support
      v.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    win.vm.synced_folder ".", "/vagrant", disabled: true
    win.vm.provision :file, source:  ".", destination: "$HOME"

    win.vm.provision :shell, path: "./win/enable-wsl.ps1"
    win.vm.provision :shell, path: "./win/enable-vmp.ps1"
  end
end
