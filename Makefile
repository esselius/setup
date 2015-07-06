.PHONY: link homebrew homebrew-install

link:
	./link.sh

brew:
	ruby -e "$(shell curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew-install:
	brew install fish rbenv ruby-build

vundle:
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
