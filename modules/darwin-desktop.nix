{ inputs, pkgs, ... }:

{
  services = {
    yabai = {
      enable = true;
      package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.yabai;
      # package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.yabai.overrideAttrs (old: {
      #   nativeBuildInputs = with pkgs; [ xxd xcbuild ];

      #   preBuild = ''
      #     sed -i 's/ -arch arm64e//g' makefile
      #   '';

      #   src = pkgs.fetchFromGitHub {
      #     owner = "koekeishiya";
      #     repo = "yabai";
      #     rev = "master";
      #     sha256 = "sha256-kMPf+g+7nMZyu2bkazhjuaZJVUiEoJrgxmxXhL/jC8M=";
      #   };
      # });

      enableScriptingAddition = false;

      config = {
        external_bar = "all:26:0";
        layout = "bsp";

        top_padding = "10";
        bottom_padding = "10";
        left_padding = "10";
        right_padding = "10";
        window_gap = "10";

        auto_balance = "on";

        mouse_modifier = "alt";
        mouse_drop_action = "swap";
      };

      extraConfig = ''
        yabai -m rule --add app="^System Preferences$" manage=off
        yabai -m rule --add app="^Activity Monitor$" manage=off sticky=on layer=above
        yabai -m rule --add app="^Viscosity$" manage=off
        yabai -m rule --add app="^Intel Power Gadget$" manage=off
        yabai -m rule --add app="^Screen$" manage=off
      '';
    };

    spacebar = {
      enable = true;
      package = pkgs.spacebar;

      config = {
        position = "top";
        height = 26;
        text_font = ''"Fira Code:Retina:15"'';
      };
    };

    skhd = {
      enable = true;

      skhdConfig = ''
        # move window
        shift + cmd - h : yabai -m window --warp west  || yabai -m window --display west
        shift + cmd - j : yabai -m window --warp south || yabai -m window --display south
        shift + cmd - k : yabai -m window --warp north || yabai -m window --display north
        shift + cmd - l : yabai -m window --warp east  || yabai -m window --display east

        # toggle split
        shift + alt - space : yabai -m window --toggle split

        # rebalance space
        shift + cmd - space  : yabai -m space --balance

        # toggle fullscreen
        shift + cmd - return : yabai -m window --toggle zoom-fullscreen

        # open terminal
        # alt - return         : open -a kitty
      '';
    };
  };

  fonts = {
    enableFontDir = true;
    fonts = [
      pkgs.fira-code
    ];
  };

  system.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = true;
    };
    finder = {
      # Bug: Switching to another display with yabai makes it click everything you hover if having disabled desktop icons:
      # https://github.com/koekeishiya/yabai/issues/637#issuecomment-772814115
      CreateDesktop = true;
    };
  };
}
