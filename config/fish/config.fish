# Homebrew
set -x PATH /usr/local/bin /usr/local/sbin $PATH

# Fry
. /usr/local/share/fry/fry.fish
set -U fry_auto_switch 1
set fish_color_user 5f8700
set fish_color_host afd75f

# Locale stuff
set -x LANG "sv_SE.UTF-8"
set -x LC_COLLATE "sv_SE.UTF-8"
set -x LC_CTYPE "sv_SE.UTF-8"
set -x LC_MESSAGES "sv_SE.UTF-8"
set -x LC_MONETARY "sv_SE.UTF-8"
set -x LC_NUMERIC "sv_SE.UTF-8"
set -x LC_TIME "sv_SE.UTF-8"
