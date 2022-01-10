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
    ];

    brews = [
      "postgresql"
    ];
  };
}
