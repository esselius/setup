# Dotfiles

Following this post:

https://www.atlassian.com/git/tutorials/dotfiles

## Install stuff

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

$ brew tap wata727/tflint
$ brew tap adoptopenjdk/openjdk
$ brew tap homebrew/cask-fonts

$ brew cask install docker adoptopenjdk adoptopenjdk8 google-cloud-sdk gpg-suite-no-mail homebrew/cask-drivers/yubico-authenticator gitify the-unarchiver alfred iterm2 font-fira-code

$ brew install sops fzf python jq gettext cmatrix tree socat fish tmux sbt nmap vim stern ghq golang ripgrep watch hub kubernetes-cli tflint terraform node python2 python3 terminal-notifier yubikey-personalization maven postgres ykman pinentry-mac wget hopenpgp-tools paperkey pv bfg git-lfs fzy pstree starship gnu-sed helm goreleaser/tap/goreleaser minikube kustomize hey

$ brew install https://gist.githubusercontent.com/lalyos/28b35c29d4f8d2c1f293/raw/sshpass.rb

$ npm install -g github-org-repos

$ go get github.com/motemen/github-list-starred
```
## Get gpg ssh agent support running

```
$ echo enable-ssh-support >> ~/.gnupg/gpg-agent.conf

$ export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

```

## Bootstrap dotfiles

```
$ alias c='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

$ git clone --bare git@github.com:esselius/dotfiles.git $HOME/.cfg

$ c checkout

$ c config --local status.showUntrackedFiles no
```

## Install vim plugins

```
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$ vim +PlugInstall
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
$ fisher
$ set -U FZF_LEGACY_KEYBINDINGS 0
$ set -U FZF_COMPLETE 2
```

## Decrypt config files

```
# Does not work perfectly out of the box yet
$ c-secret-sync
```

## Install app from Mac App store

- Telegram
- Gifwit
- Keynote
- Numbers
- Bredbandskollen
- Magnet
- Slack

## Install apps from internet sites

- Viscosity VPN Client: https://www.sparklabs.com/viscosity/download/
- Intellij IDE: https://www.jetbrains.com/idea/download/#section=mac
- Goland IDE: https://www.jetbrains.com/go/
- VsCode Editor: https://code.visualstudio.com/docs/?dv=osx
- Flux blue light limiter: https://justgetflux.com/news/pages/macquickstart/
- Google Chat: https://chat.google.com/download/
- Spotify: https://www.spotify.com/se/download/mac
- Steam: https://store.steampowered.com/about/

## Finishing up

- Enter Alfred license key
- Enter Viscosity license key
- Set iTerm2 to use Fira Code font
- Launch Docker.app and give the VM 8GB memory
- Import Gifwit-library `open .library.gifwit`
- Clone git repos

```
$ github-list-starred esselius | ghq import -P
$ github-list-org-repos $ORG | ghq import -P
$ gitosis-list-repos | ghq import -P
```
