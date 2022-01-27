{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  time.timeZone = "Europe/Stockholm";

  services.xserver = {
    enable = true;
    layout = "us";

    autoRepeatDelay = 225;
    autoRepeatInterval = 30;

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };

    windowManager = {
      i3.enable = true;
    };
  };
}
