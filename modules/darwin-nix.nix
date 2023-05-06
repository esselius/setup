{ pkgs, ... }:

{
  nix = {
    useDaemon = true;
    settings.sandbox = true;
    extraOptions = ''
      extra-experimental-features = nix-command flakes
      warn-dirty = false
    '';
    configureBuildUsers = true;
  };

  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
