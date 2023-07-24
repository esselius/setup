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
      "gromgit/fuse"
    ];

    casks = [
      "1password-beta"
      "alfred"
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
      "1password-cli"
      "dataspell"
      "macfuse"
      "notion"
      "obsidian"
      "odbc-manager"
      "plex-media-server"
      "visual-studio-code"
      "vlc"
    ] ++ (if pkgs.system == "x86_64-darwin" then [ "intel-power-gadget" ] else [ ]);

    brews = [
      "azure-cli"
      "dhall-yaml"
      "duckdb"
      "hub"
      "xz"
    ];
  };
}
