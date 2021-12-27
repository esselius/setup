{ pkgs, ... }: {
  nix = {
    extraOptions = ''
      extra-experimental-features = nix-command flakes
      use-registries = false
      warn-dirty = false
    '';

    binaryCaches = [
      "https://cache.nixos.org"
      "https://esselius.cachix.org"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "esselius.cachix.org-1:w6SK4Jb27KNtsewkVfmiFhVRERQ5WBnZ5H7pULvLxVg="
    ];
  };

  environment.systemPackages = [ pkgs.git ];
}
