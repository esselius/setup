# setup

## NixOS

```shell
$ nix run .#nixosVagrantBox -L
$ vagrant up
$ vagrant ssh
```

```shell
$ sudo nixos-rebuild switch --flake /vagrant
```

## Ubuntu

```shell
$ vagrant up ubuntu
$ vagrant ssh ubuntu
```

```shell
$ nix run /vagrant#home-manager -- switch --flake /vagrant#vagrant
```

## MacOS

[Vagrant MacOS Box](https://github.com/trodemaster/packer-macOS-11)

```shell
$ vagrant up
```

```shell
$ git clone https://github.com/esselius/setup.git
$ cd setup

$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
$ curl -sSfL https://nixos.org/nix/install | sh -s -- --daemon --nix-extra-conf-file nix.conf

$ echo -e 'run\tprivate/var/run' | sudo tee -a /etc/synthetic.conf
$ /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
$ sudo rm -rf ~/.nix-defexpr
$ nix-channel --update

$ nix --extra-experimental-features nix-command run .#darwin -- switch --flake .#vagrant
```
