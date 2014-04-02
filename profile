export RBENV_ROOT=/usr/local/var/rbenv

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

. ~/.exports

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
alias gc='git checkout'
alias gcp='git cherry-pick'

export JAVA_HOME="$(/usr/libexec/java_home)"
#export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
#export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
export AWS_AUTO_SCALING_HOME="/usr/local/Cellar/auto-scaling/1.0.61.4/libexec"
