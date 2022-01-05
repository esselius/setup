# setup

## Usage

### MacOS

```shell
$ nix run .#darwin-rebuild -- switch --flake .
```

## Development

### NixOS

```shell
$ nix run .#packer-nixos -L
$ vagrant box add nixos_vmware.box --name nixos --force
$ rm nixos_vmware.box
```

```shell
$ vagrant up
```

### Nested NixOS

```shell
$ nix run /vagrant#nixos-vm
```

### Ubuntu

```shell
$ vagrant up ubuntu
```

### MacOS

[Vagrant MacOS Box](https://github.com/trodemaster/packer-macOS-11)

```shell
$ vagrant up macos
```

Allow VMware kernel extension in system settings

```shell
# Install homebrew
$ curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

# Install nix
$ curl -sSfL https://nixos.org/nix/install | sh -s -- --daemon

# Create /run
$ echo -e 'run\tprivate/var/run' | sudo tee -a /etc/synthetic.conf
$ /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# Create ~/.nix-defexpr
$ nix-channel --update

# Move /etc files out of the way for switch to work
$ sudo mv /etc/shells{,.bak}
$ sudo mv /etc/nix/nix.conf{,.bak}

# Switch system config
$ nix --extra-experimental-features 'nix-command flakes' run github:esselius/setup#darwin-rebuild -- switch --flake github:esselius/setup#vagrant

# Change user shell
$ chsh -s /run/current-system/sw/bin/fish
```

Allow skhd, yabai & spacebar in system settings
