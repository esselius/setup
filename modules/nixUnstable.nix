{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
  };
}
