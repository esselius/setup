set fish_greeting

set -x EDITOR vim

set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

. ~/.config/fish/env.fish
. ~/.config/fish/ssh.fish

function __prompt_context_reload -v __prompt_context_current
  echo $__prompt_context_current
end
