set fish_greeting

set -x EDITOR vim

if functions setup-wrk > /dev/null
  setup-wrk
end

set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1

function __prompt_context_reload -v __prompt_context_current
  echo $__prompt_context_current
end
