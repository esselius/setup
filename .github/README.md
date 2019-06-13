# Dotfiles

Following this post:

https://www.atlassian.com/git/tutorials/dotfiles

## Install stuff

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

$ brew tap wata727/tflint

$ brew cask install adoptopenjdk google-cloud-sdk


$ brew install python jq gettext cmatrix tree socat fish tmux sbt nmap vim stern ghq golang ripgrep watch hub kubernetes-cli tflint terraform node python2 python3

$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$ vim +PlugInstall

$ go get github.com/motemen/github-list-starred
```

## Bootstrap dotfiles

```
$ alias c='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

$ git clone --bare git@github.com:esselius/dotfiles.git $HOME/.cfg

$ c checkout

$ c config --local status.showUntrackedFiles no
```

## Switch shell

```
$ echo /usr/local/bin/fish | sudo tee -a /etc/shells

$ chsh -s /usr/local/bin/fish
```

## Update $PATH

```
$ set -U fish_user_paths ~/.bin ~/go/bin /usr/local/opt/gettext/bin $fish_user_paths
```
