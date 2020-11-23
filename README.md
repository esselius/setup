# nix-config

## Getting Started

### Vagrant

Install vagrant & virtualbox

```shell
# MacOS
$ brew install vagrant virtualbox virtualbox-extension-pack

# Ubuntu
$ sudo apt install vagrant virtualbox virtualbox-ext-pack
```

Bootstrap VMs

```shell
$ vagrant up
```

### MacOS

```shell
$ ./mac/provision.sh
```

### Linux

```shell
$ ./linux/provision.sh
```

### Windows

```shell
$ ./win/provision.sh
```

## Implementation

### Darwin

Provision vagrant using zsh-script

1. Symlink config files
2. Install multi-user nix
3. Install nix-darwin
4. Install nix flakes
5. Use home-manager, via nix-darwin

### Linux

Provision vagrant using bash-script

1. Symlink config files
2. Install multi-user nix
3. Install home-manager
4. Install nix flakes
5. Use home-manager

### Windows
