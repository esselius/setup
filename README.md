# setup

## NixOS

```shell
$ nix run .#nixosVagrantBox -L
$ vagrant up
$ vagrant ssh
$ sudo nixos-rebuild switch --flake /vagrant
```

## Ubuntu

```shell
$ vagrant up ubuntu
$ vagrant ssh ubuntu
$ nix run /vagrant#home-manager -- switch --flake /vagrant#vagrant
```

## MacOS

[Vagrant MacOS Box](https://github.com/trodemaster/packer-macOS-11)

```shell
$ vagrant up
$ git # Triggers install of Xcode CLI Tools
$ sh <(curl -sSfL https://nixos.org/nix/install) --daemon
$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
$ git clone https://github.com/esselius/setup.git
$ cd setup
$ nix --extra-experimental-features nix-command run .#darwin -- build --flake .
```
