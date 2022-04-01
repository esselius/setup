{ pkgs, ... }: {
  programs.gpg = {
    enable = false;
  };

  services.gpg-agent.enable = pkgs.hostPlatform.isLinux;
}
