# Dotfiles

Following this post:

https://www.atlassian.com/git/tutorials/dotfiles

## Install stuff

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

$ brew tap wata727/tflint
$ brew tap adoptopenjdk/openjdk

$ brew cask install adoptopenjdk adoptopenjdk8 google-cloud-sdk gpg-suite-no-mail yubico-authenticator gitify the-unarchiver

$ brew install python jq gettext cmatrix tree socat fish tmux sbt nmap vim stern ghq golang ripgrep watch hub kubernetes-cli tflint terraform node python2 python3 terminal-notifier yubikey-personalization maven postgres ykman pinentry-mac wget hopenpgp-tools paperkey pv bfg git-lfs

$ brew install https://gist.githubusercontent.com/lalyos/28b35c29d4f8d2c1f293/raw/sshpass.rb

$ npm install -g github-org-repos

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

## Configure fisher plugins

```
$ set -U FZF_LEGACY_KEYBINDINGS 0
$ set -U FZF_COMPLETE 2
```
