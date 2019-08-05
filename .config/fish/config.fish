set fish_greeting

set -x EDITOR vim

set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

function __prompt_context_reload -v __prompt_context_current
  echo $__prompt_context_current
end

if status --is-interactive
  set -g fish_user_abbreviations

  function _clear_fish_abbreviations
    for x in (abbr -l)
      abbr -e $x
    end
  end

  # kubectl
  abbr -a k 'kubectl'
  abbr -a kcuc 'kubectl config use-context'
  abbr -a kccc 'kubectl config current-context'

  # git
  alias gs='git status -sb'
  alias gd='git diff'
  alias gmsg='git commit -m'
  alias gcam='git commit -a -m'
  alias gcan!='git commit -v -a --no-edit --amend'
  abbr -a gc 'git checkout'
  abbr -a gco 'git checkout'
  alias gcb='git checkout -b'
  alias gl='git pull'

  function _git_current_branch
    git rev-parse --abbrev-ref HEAD
  end

  alias gpsup='git push --set-upstream origin (_git_current_branch)'
  alias gp='git push'
  alias gpf='git push --force-with-lease'

  # ghq
  abbr -a glo 'ghq look'
  abbr -a gim 'ghq import'

  # dotfiles
  alias c='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
  abbr -a cgs 'c status -sb'
  abbr -a cgmsg 'c commit -m'
end

# GPG stuff
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -x GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye > /dev/null

# For all those secrets
if test -e ~/.config/fish/env.fish
  source ~/.config/fish/env.fish
end
