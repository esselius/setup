#!/usr/bin/env zsh

set -e

main() {
    nix_config_dir="${1:-"${PWD}"}"

    echo --------- STEP 1 --------------

    mkdir -p ~/.nixpkgs
    ln -s "${nix_config_dir}/mac/darwin-configuration.nix" ~/.nixpkgs/darwin-configuration.nix

    mkdir -p ~/.config/nixpkgs
    ln -s "${nix_config_dir}/mac/home.nix" ~/.config/nixpkgs/home.nix

    echo --------- STEP 2 --------------

    sh <(curl -L https://nixos.org/nix/install) --daemon --darwin-use-unencrypted-nix-store-volume
    mkdir -p ~/.nix-defexpr

    echo --------- STEP 3 --------------

    . /etc/zshrc

    sudo mv /etc/nix/nix.conf{,.bak}

    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    ./result/bin/darwin-installer
    rm -rf result

    echo --------- STEP 4 --------------

    . /etc/zshrc

    nix-channel --add  https://nixos.org/channels/nixpkgs-20.09-darwin nixpkgs
    nix-channel --update

    nix-env -iA nixpkgs.nixFlakes

    sudo killall nix-daemon
    sleep 1

    echo --------- STEP 5 --------------

    . /etc/zshenv

    darwin-rebuild switch --flake "${nix_config_dir}/mac"

    echo --------- DONE ! --------------
}

main "$@"
