# nix-config

## Getting Started

```shell
# Windows only: Enter WSL
PS C:\Users\vagrant\nix-config> wsl

# All
$ ./provision.sh
```

## Implementation

### Darwin

Provision using a zsh-script

1. Symlink config files
2. Install multi-user nix
3. Install nix-darwin
4. Install nix flakes
5. Use home-manager, via nix-darwin

### Linux

Provision using a bash-script

1. Symlink config files
2. Install multi-user nix
3. Install home-manager
4. Install nix flakes
5. Use home-manager

### Windows

Automatically provision WSL and manually run Ubuntu nix provisioing bash-script

1. Setup WSL
   1. Enable WSL support
   2. Install Ubuntu via Chocolatey
2. Provisioning script for Ubuntu @ WSL1
   1. Symlink config files
   2. Install single-user nix
   3. Install home-manager
   4. Install nix flakes
   5. Use home-manager

## Development

### Vagrant

Install host tooling

```shell
# MacOS
$ brew install vagrant virtualbox virtualbox-extension-pack

# Ubuntu
$ sudo apt install vagrant virtualbox virtualbox-ext-pack

# Windows
# TODO choco ExtensionPack install is apparently currently broken ¯\_(ツ)_/¯
$ choco install vagrant virtualbox --params "/ExtensionPack"
```

Bootstrap VMs

```shell
$ vagrant up
<output>
```
