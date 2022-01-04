{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    useDaemon = true;
    useSandbox = true;
    extraOptions = ''
      extra-experimental-features = nix-command flakes
      warn-dirty = false
    '';
  };

  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  users.nix.configureBuildUsers = true;
}
