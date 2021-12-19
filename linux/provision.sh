#!/usr/bin/env bash

[[ "${TRACE}" ]] && set -x
set -eou pipefail
shopt -s nullglob

main() {
    nix_config_dir="${1:-"${PWD}"}"

    echo --------- STEP 1 --------------

    mkdir -p ~/.config/nixpkgs
    ln -s "${nix_config_dir}/linux/home.nix" ~/.config/nixpkgs/home.nix

    echo --------- STEP 2 --------------

    sh <(curl -L https://nixos.org/nix/install) --daemon
    . /etc/profile.d/nix.sh

    echo --------- STEP 3 --------------

    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update

    # Needs to be moved out of the way for home-manager to take over
    mv ~/.profile{,.bak}
    mv ~/.bashrc{,.bak}

    export NIX_PATH="$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH"
    nix-shell '<home-manager>' -A install

    echo --------- STEP 4 --------------

    nix-env -iA nixpkgs.nixFlakes

    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    sudo killall nix-daemon
    sleep 1

    echo --------- STEP 5 --------------

    home-manager switch

    echo --------- DONE ! --------------
}

main "$@"
