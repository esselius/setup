{
  homebrew = {
    enable = true;

    global = {
      noLock = true;
      brewfile = true;
    };
    cleanup = "zap";

    taps = [
      "homebrew/cask"
      "koekeishiya/formulae"
    ];

    casks = [
      "1password"
      "alfred"
      "datagrip"
      "geekbench"
      "google-chrome"
      "google-cloud-sdk"
      "houseparty"
      "intel-power-gadget"
      "istat-menus"
      "microsoft-teams"
      "steam"
      "vagrant-vmware-utility"
      "viscosity"
      "vmware-fusion"
      "mactex-no-gui"
      "goland"
      "postman"
      "intellij-idea"
      "parallels"
    ];

    brews = [
      "postgresql"
      "pandoc"
      "trino"
      "metabase"
      "operator-sdk"
      "yabai"
      "azure-cli"
    ];
  };
}
