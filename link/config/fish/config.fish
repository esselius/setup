set fish_greeting

set -x EDITOR vim

setup-wrk

set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1

function __prompt_context_reload -v __prompt_context_current
  echo $__prompt_context_current
end
