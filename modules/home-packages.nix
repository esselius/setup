{ pkgs, lib, ... }:
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
    azure-cli
    jq
    google-cloud-sdk
  ];
  linuxPackages = with pkgs; [
    firefox
    jetbrains.datagrip
    killall
  ];
  darwinPackages = with pkgs; [

  ];
in
{
  home.packages = globalPackages ++ (if pkgs.hostPlatform.isLinux then linuxPackages else darwinPackages);
}
