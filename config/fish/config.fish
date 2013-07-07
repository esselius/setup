# Colors
set fish_color_user 5f8700
set fish_color_host afd75f

# Locale stuff
set -x LC_ALL "en_US.UTF-8"

# Boxen
. (dirname (status -f))/boxen.fish

# Less colors
set -x LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
set -x LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
set -x LESS_TERMCAP_me \e'[0m'           # end mode
set -x LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
set -x LESS_TERMCAP_se \e'[0m'           # end standout-mode
set -x LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline
set -x LESS_TERMCAP_ue \e'[0m'           # end underline
