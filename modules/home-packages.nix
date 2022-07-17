{ pkgs, lib, homebrewBin, ... }:
let
  globalPackages = with pkgs; [
    ripgrep
    fzf
    vagrant
    packer
    stern
    vim
    kubectl
    watch
    kustomize
    clickhouse-cli
    jq
    google-cloud-sdk
    docker-compose
    (sbt.override { jre = jre8; })
    (flink.override { jre = jre8; })
    jdk
    kind
    kubernetes-helm
    gnumake
    krew
    tilt
    k9s
    socat
    nodejs
    git
    nixpkgs-fmt
    cmatrix
    qemu
    go
    gopls
    delve
    vscode
  ];
  linuxPackages = with pkgs; [
    firefox
    jetbrains.datagrip
    killall
    jetbrains.idea-ultimate
    jetbrains.datagrip
    kube3d
    sysstat
  ];
  darwinPackages = with pkgs; [

  ];
in
{
  home = {
    packages = globalPackages ++ (if pkgs.hostPlatform.isLinux then linuxPackages else darwinPackages);
    sessionPath = [
      homebrewBin
    ];
  };
}
