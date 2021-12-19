{ pkgs, ... }:

{
  home = {
    packages = [
      pkgs.nixFlakes
    ];
  };

  programs = {
    bash.enable = true;
    home-manager.enable = true;
  };
}