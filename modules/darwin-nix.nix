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
}
