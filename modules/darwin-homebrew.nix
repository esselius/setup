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
      "vmware-fusion"
      "vagrant-vmware-utility"
    ];
  };
}
