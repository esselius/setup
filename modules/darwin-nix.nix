{ pkgs, ... }:

{
  nix = {
    useDaemon = true;
    settings = {
      sandbox = true;
      trusted-users = ["root" "@admin"];
    };
    extraOptions = ''
      extra-experimental-features = nix-command flakes
      warn-dirty = false
    '';
    configureBuildUsers = true;
  };

  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
