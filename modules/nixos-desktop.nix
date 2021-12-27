{
  services.xserver = {
    enable = true;
    layout = "us";

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };

    windowManager = {
      i3.enable = true;
    };
  };
}
