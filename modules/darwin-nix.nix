{
  nix = {
    useDaemon = true;
    useSandbox = true;
    extraOptions = ''
      extra-experimental-features = nix-command flakes
      use-registries = false
      warn-dirty = false
    '';
  };

  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  users.nix.configureBuildUsers = true;
}
