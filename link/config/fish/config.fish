set fish_greeting

set -x EDITOR vim

set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

. ~/.config/fish/env.fish
. ~/.config/fish/ssh.fish

function __prompt_context_reload -v __prompt_context_current
  echo $__prompt_context_current
end

set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths

if status --is-interactive
  set -g fish_user_abbreviations
  abbr -a kt stern
  abbr -a kc kubectl
  abbr -a kcu 'kubectl config use-context'
  abbr -a kcl 'kubectl logs -f'
  abbr -a kcp 'kubectl get pods'
  abbr -a gl 'ghq look'
end

alias kca='kubectl apply -f'
alias kcn='kubectl -n kube-system'
alias prjle='hub pull-request -a esselius -r thrawny'
source ~/.asdf/asdf.fish
