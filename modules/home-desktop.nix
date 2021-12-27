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
}
