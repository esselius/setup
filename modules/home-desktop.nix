{ pkgs, lib, ... }:
{
  xsession = lib.mkIf pkgs.hostPlatform.isLinux {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal =
          if pkgs.isNixOS then
            "${pkgs.kitty}/bin/kitty" else "${pkgs.wrapWithNixGLIntel pkgs.kitty}/bin/kitty";
      };
    };
  };

  programs = {
    kitty = {
      enable = true;
      font = {
        name = "Fira Code";
        package = pkgs.fira-code;
      };
      settings = {
        font_size = "12.0";
        cursor_shape = "underline";
        clipboard_control = "write-clipboard write-primary no-append";
      };
    };
  };
}
