{ pkgs, ... }:

{
  programs = {
    bash = {
      enable = true;
      profileExtra = ''
        export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
      '';
    };
    home-manager.enable = true;
  };
}