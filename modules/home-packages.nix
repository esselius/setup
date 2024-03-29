{ pkgs, ... }:
let
  globalPackages = with pkgs; [
    ripgrep
    fzf
    # vagrant
    # packer
    stern
    vim
    kubectl
    watch
    # kustomize
    # clickhouse-cli
    jq
    google-cloud-sdk
    docker-compose
    (sbt.override { jre = jre8; })
    # (flink.override { jre = jre8; })
    jdk
    kind
    # kubernetes-helm
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
    earthly
    # octant
    minio-client
    nil
  ];
  linuxPackages = [ ];
  darwinPackages = with pkgs; [
    # tart
    utm
   ];
in
{
  home = {
    packages = globalPackages ++ (if pkgs.hostPlatform.isLinux then linuxPackages else darwinPackages);
  };
}
