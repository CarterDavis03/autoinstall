#!/bin/bash

yayinstall() {
	cd ~/.local/src
	sudo pacman -Sy base-devel go git
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..
	rm -fr yay
}

installpkgs() {
	yay -Sy ani-cli-git biber blueman bluez chromium clipit curl dunst fish flameshot fzf git htop hunspell hunspell-en_gb i3lock imagemagick keepassxc libreoffice-fresh mpv neovim nitrogen ntfs-3g nvidia nvidia-settings nvidia-utils pamixer pandoc picom pipewire-pulse pulsemixer python python-neovim ranger rofi spaceship-prompt sxiv texlive-most unclutter unzip w3m wget xclip xorg-xinit xorg-xprop xorg-xrandr xorg-xset xtrlock zathura zathura-pdf-mupdf zathura-ps zsh zsh-autosuggestions zsh-syntax-highlighting zsh-you-should-use
}

nerdfonts() {
	cd ~/.local/src
	git clone https://github.com/ryanoasis/nerd-fonts.git
	cd nerd-fonts
	sudo chmod +x install.sh
	./install.sh
	cd ..
	rm -fr nerd-fonts
}


mkdir -pv ~/.local/src

# Disable sudo timeout
while :; do sudo -v; sleep 59; done &

yayinstall
installpkgs
nerdfonts
