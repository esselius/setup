{ pkgs, lib, ... }:
{
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
        confirm_os_window_close = 0;
      };
    };
  };
}
