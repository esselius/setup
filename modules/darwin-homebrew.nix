{ pkgs, ... }: {
  homebrew = {
    enable = true;

    global = {
      brewfile = true;
    };
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };

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
      "dropbox"
      "obsidian"
      "notion"
      "visual-studio-code"
      "plex-media-server"
      "1password-cli"
    ] ++ (if pkgs.system == "x86_64-darwin" then [ "intel-power-gadget" ] else [ ]);

    brews = [
      "postgresql@14"
      "azure-cli"
      "k3d"
      "tilt-dev/tap/tilt"
      "dhall-yaml"
    ];
  };
}
