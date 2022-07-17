{ pkgs, ... }: {
  homebrew = {
    enable = true;

    global = {
      noLock = true;
      brewfile = true;
    };
    cleanup = "zap";

    taps = [
      "homebrew/cask"
      "homebrew/cask-versions"
      "koekeishiya/formulae"
      "tilt-dev/tap"
    ];

    casks = [
      "1password-beta"
      "alfred"
      "camo-studio"
      "chromedriver"
      "cyberduck"
      "datagrip"
      "docker"
      "geekbench"
      "goland"
      "google-chrome"
      "google-cloud-sdk"
      "houseparty"
      "intellij-idea"
      "intune-company-portal"
      "istat-menus"
      "joplin"
      "microsoft-teams"
      "parallels"
      "pop"
      "screens-connect"
      "screens"
      "slack"
      "spotify"
      "steam"
      "telegram"
      "transmission"
      "viscosity"
    ] ++ (if pkgs.system == "x86_64-darwin" then [ "intel-power-gadget" ] else [ ]);

    brews = [
      "postgresql"
      "yabai"
      "azure-cli"
      "k3d"
      "tilt-dev/tap/tilt"
    ];
  };
}
