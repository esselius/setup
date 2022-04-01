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
    chromedriver
    jq
    google-cloud-sdk
    docker-compose
    (sbt.override { jre = jre8; })
    (flink.override { jre = jre8; })
    #jdk8
    kind
    kubernetes-helm
    gnumake
    krew
    tilt
    k9s
    socat
    hub
    ngrok-2
    nodejs
    git
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
