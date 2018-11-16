set fish_greeting

set -x EDITOR vim

set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

. ~/.config/fish/env.fish
. ~/.config/fish/ssh.fish

function __prompt_context_reload -v __prompt_context_current
  echo $__prompt_context_current
end

set -g fish_user_paths "/usr/local/opt/sphinx-doc/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths

alias kc='kubectl'
alias kt='stern'
alias kca='kubectl apply -f'
alias kcn='kubectl -n kube-system'
alias kcp='kubectl get pods'
alias kcl='kubectl logs -f'
alias kcu='kubectl config use-context'
alias prjle='hub pull-request -a esselius -r thrawny'
