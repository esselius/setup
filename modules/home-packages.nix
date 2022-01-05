{ pkgs, lib, ... }:
let
  globalPackages = with pkgs; [
    ripgrep
    fzf
    vagrant
    packer
  ];
  linuxPackages = with pkgs; [
    firefox
  ];
  darwinPackages = with pkgs; [

  ];
in
{
  home.packages = globalPackages ++ (if pkgs.hostPlatform.isLinux then linuxPackages else darwinPackages);
}
