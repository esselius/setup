# Dotfiles

Following this post:

https://www.atlassian.com/git/tutorials/dotfiles

## Install stuff

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

$ brew cask install adoptopenjdk

$ brew install python jq gettext cmatrix tree socat fish tmux sbt nmap

$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$ vim +PlugInstall
```

## Bootstrap dotfiles

```
$ alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

$ git clone --bare git@github.com:esselius/dotfiles.git $HOME/.cfg

$ config checkout

$ config config --local status.showUntrackedFiles no
```
