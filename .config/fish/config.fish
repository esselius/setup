set -g fish_user_paths /usr/local/sbin ~/go/bin /usr/local/MacGPG2/bin $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
set -g fish_user_paths ~/.krew/bin $fish_user_paths

set fish_greeting

set -x EDITOR vim

set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

#function __prompt_context_reload -v __prompt_context_current
#  echo $__prompt_context_current
#end

if status --is-interactive
  set -g fish_user_abbreviations

  function _clear_fish_abbreviations
    for x in (abbr -l)
      abbr -e $x
    end
  end

  # kubectl
  abbr -a k    'kubectl'
  abbr -a kcuc 'kubectl config use-context'
  abbr -a kccc 'kubectl config current-context'
  abbr -a kscn 'kubectl config set-context --current --namespace'

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

  # Github
  abbr -a ghub 'hub pull-request -a esselius'

  # Ripgrep
  abbr -a rg 'rg -S --hidden --glob "!.git/*"'

  # ghq
  abbr -a gim 'ghq import'

  # dotfiles
  alias c='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
  abbr -a cgs 'c status -sb'
  abbr -a cgmsg 'c commit -m'

  alias mp=microplane
end

# GPG stuff
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -x GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

# For all those secrets
if test -e ~/.config/fish/env.fish
  source ~/.config/fish/env.fish
end

if which starship >/dev/null
  starship init fish | source
end

if which socat >/dev/null && test -S /var/run/docker.sock && ! ps aux | grep -q "socat TCP-LISTEN.*docker\.sock"
  socat TCP-LISTEN:2375,reuseaddr,fork,bind=localhost UNIX-CONNECT:/var/run/docker.sock &
  disown
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish ; or true

source ~/.asdf/asdf.fish
