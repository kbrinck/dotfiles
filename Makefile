.PHONY: bash kitty nvim vim zsh dev codex yazi niri

bash:
	stow --adopt  bash

kitty:
	stow --adopt  kitty
	sudo pacman -S kitty

yazi:
	stow yazi
	sudo pacman -S yazi

nvim:
	stow --adopt  nvim
	sudo pacman -S neovim pyright

vim:
	stow --adopt  vim
	sudo pacman -S gvim

zsh:
	stow --adopt zsh 
	sudo pacman -S bat eza fzf zoxide starship ripgrep btop

dev:
	sudo pacman -S git pycharm-community-edition code uv

codex:
	npm install -g @openai/codex

niri:
	stow niri noctalia
	sudo pacman -S niri noctalia

