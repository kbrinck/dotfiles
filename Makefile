.PHONY: bash kitty nvim vim zsh dev

bash:
	stow bash

kitty:
	stow kitty

nvim:
	stow nvim
	sudo pacman -S neovim pyright

vim:
	stow vim
	sudo pacman -S gvim

zsh:
	stow zsh
	sudo pacman -S eza fzf zoxide starship ripgrep btop

dev:
	sudo pacman -S git pycharm-community-edition code uv
