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