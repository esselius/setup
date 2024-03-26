{
  nix = {
    useDaemon = true;
    settings = {
      sandbox = false;
      trusted-users = [ "@admin" ];
    };
    extraOptions = ''
      extra-experimental-features = nix-command flakes
      warn-dirty = false
    '';
    configureBuildUsers = true;

    linux-builder = {
      enable = true;
      maxJobs = 8;
      ephemeral = true;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 100 * 1024;
            memorySize = 16 * 1024;
          };
          cores = 8;
        };
      };
    };
  };

  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
