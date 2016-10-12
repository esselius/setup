set fish_greeting

set -x EDITOR vim

. ~/.config/fish/env.fish
. ~/.config/fish/ssh.fish

function __prompt_context_reload -v __prompt_context_current
  echo $__prompt_context_current
end
