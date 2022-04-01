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
    ];

    casks = [
      "1password-beta"
      "alfred"
      "datagrip"
      "geekbench"
      "google-chrome"
      "google-cloud-sdk"
      "houseparty"
      "istat-menus"
      "microsoft-teams"
      "steam"
      "vagrant-vmware-utility"
      "viscosity"
      "vmware-fusion"
      "goland"
      "intellij-idea"
      "parallels"
      "telegram"
      "kitty"
      "docker"
      "screens"
      "screens-connect"
      "spotify"
      "camo-studio"
    ] ++ (if pkgs.system == "x86_64-darwin" then [ "intel-power-gadget" ] else [ ]);

    brews = [
      "postgresql"
      "yabai"
      "azure-cli"
    ];
  };
}
