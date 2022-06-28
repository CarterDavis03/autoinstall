#!/bin/bash

laptopcheck() {
	while true; do
	    read -p "Are you installing on a laptop/16:9 screen? [y/N]" yn
	    case $yn in
	        [Yy]* ) LAPTOP=true; break;;
	        [Nn]* ) LAPTOP=false; break;;
	        * ) LAPTOP=false; break;;
	    esac
	done
}

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
	yay -Sy ani-cli-git biber blueman bluez chromium clipit curl dunst feh fish flameshot fzf git htop hunspell hunspell-en_gb i3lock imagemagick keepassxc libreoffice-fresh mpv neovim ntfs-3g nvidia nvidia-settings nvidia-utils pamixer pandoc picom pipewire-pulse pulsemixer python python-neovim ranger rofi solaar spaceship-prompt sxiv texlive-most unclutter unzip w3m wget xclip xorg-xinit xorg-xprop xorg-xrandr xorg-xset xtrlock zathura zathura-pdf-mupdf zathura-ps zsh zsh-autosuggestions zsh-syntax-highlighting zsh-you-should-use
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

dwminstall() {
	cd ~/.local/src
	git clone https://github.com/CarterDavis03/dwm.git
	cd dwm

	if [[ "${LAPTOP}" == "true" ]]; then
		git checkout -b laptop
		sed -i 's/:size=16/:size=12/g' config.h
	fi

	sudo make clean install
	sudo chmod +x autostart.sh
	mkdir -pv ~/.dwm
	ln -s ./autostart.sh ~/.dwm/
}

stinstall() {
	cd ~/.local/src
	git clone https://github.com/CarterDavis03/st.git
	cd st

	if [[ "${LAPTOP}" == "true" ]]; then
		git checkout -b laptop
		sed -i 's/:pixelsize=20/:pixelsize=16/g' config.h
	fi

	sudo make clean install
}

dmenuinstall() {
	cd ~/.local/src
	git clone https://github.com/CarterDavis03/dmenu.git
	cd dmenu

	if [[ "${LAPTOP}" == "true" ]]; then
		git checkout -b laptop
		sed -i 's/:size=16/:size=12/g' config.h
	fi

	sudo make clean install
}

slstatusinstall() {
	cd ~/.local/src
	git clone https://github.com/CarterDavis03/slstatus.git
	cd slstatus
	sudo make clean install
}

bininstall() {
	cd ~/.local
	git clone https://github.com/CarterDavis03/bin.git
	cd bin
	sudo chmod +x *
}

configsinstall() {
	cd ~/.local
	git clone https://github.com/CarterDavis03/configs.git
	cd configs
	sudo chmod +x install.sh
	./install.sh headless
}

mkdir -pv ~/.local/src

# Disable sudo timeout
while :; do sudo -v; sleep 59; done &

laptopcheck
yayinstall
installpkgs
nerdfonts
dwminstall
stinstall
dmenuinstall
slstatusinstall
bininstall
configsinstall
