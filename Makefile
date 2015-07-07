.PHONY: link homebrew homebrew-install

link:
	./link.sh

brew:
	ruby -e "$(shell curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew-install:
	brew install fish rbenv ruby-build

vundle: $(HOME)/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

$(HOME)/.vim/bundle/Vundle.vim:
	git clone https://github.com/gmarik/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim
