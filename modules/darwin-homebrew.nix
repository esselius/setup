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
      "vmware-fusion"
      "vagrant"
      "vagrant-vmware-utility"
      "google-cloud-sdk"
    ];
  };
}