export RBENV_ROOT=/usr/local/var/rbenv

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

. ~/.aws_keys

# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups

# append history entries..
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
export VCPROMPT_FORMAT="%b%m"
export PS1='\u@\h:\w:$(vcprompt) '

alias gs='git status'
alias gd='git diff'
alias gcam='git commit -am'
alias ls='ls -Gla'
