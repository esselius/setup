{
  nix = {
    useDaemon = true;
    useSandbox = true;
    extraOptions = ''
      extra-experimental-features = nix-command flakes
    '';
  };
}
