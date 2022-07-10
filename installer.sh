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
	sudo pacman -Syu base-devel go git
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..
	rm -fr yay
}

installpkgs() {
	# Install drivers for my ASUS laptop
	if [[ "${LAPTOP}" == "true" ]]; then
		yay -Sy rtl8821ce-dkms-git acpilight
	fi

	yay -Sy ani-cli-git biber blueman bluez bluez-utils bluez-libs chromium clipit curl dunst feh fish flameshot fzf git htop hunspell hunspell-en_gb i3lock imagemagick keepassxc libreoffice-fresh mpv neovim ntfs-3g nvidia nvidia-settings nvidia-utils pamixer pandoc picom pipewire-pulse pulsemixer python python-neovim ranger rofi solaar spaceship-prompt sxiv texlive-most unclutter unzip w3m wget xclip xdotool xorg-xinit xorg-xprop xorg-xrandr xorg-xset xtrlock zathura zathura-pdf-mupdf zathura-ps zsh zsh-autosuggestions zsh-syntax-highlighting zsh-you-should-use ffmpeg yt-dlp aria2 noto-fonts-emoji libxft-bgra xidlehook filezilla man-db polkit ttf-jetbrains-mono


	sudo chsh -s /bin/zsh $USER
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
  rm -fr dwm
	git clone https://github.com/CarterDavis03/dwm.git
	cd dwm

	if [[ "${LAPTOP}" == "true" ]]; then
		git checkout -b laptop
		sed -i 's/:size=16/:size=12/g' config.h
	fi

	sudo make clean install
	sudo chmod +x autostart.sh
	mkdir -pv ~/.dwm
	ln -s $HOME/.local/src/dwm/autostart.sh ~/.dwm/
	sudo cp ./dwm.desktop /usr/share/xsessions
}

stinstall() {
	cd ~/.local/src
  rm -fr st
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
  rm -fr dmenu
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
  rm -fr slstatus
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

backgroundinstall() {
	cd ~/
	mkdir -pv Pictures/Screenshots
	cd Pictures
	git clone https://github.com/CarterDavis03/backgrounds.git
	SIZE=ultrawide
	if [[ "${LAPTOP}" == "true" ]]; then
		SIZE=normal
	fi

	echo "#!/bin/sh" > ~/.fehbg
	echo "feh --no-fehbg --bg-scale '$HOME/Pictures/backgrounds/$SIZE/akari.png'" >> ~/.fehbg
	sudo chmod +x ~/.fehbg

}

metropolisinstall() {
	cd ~/.local/src
	git clone https://github.com/matze/mtheme.git
	cd mtheme
	sudo make install
	cd ..
	sudo rm -fr mtheme
}

postinstall() {
  echo "$USER ALL=(ALL) NOPASSWD:/usr/bin/systemctl" | sudo tee -a /etc/sudoers
  sudo systemctl enable bluetooth

  echo "#!/bin/sh" > ~/pathset.sh
  echo "" >> ~/pathset.sh
  echo "export PATH=/home/$USER/.local/bin:\$PATH" >> ~/pathset.sh
  sudo mv ~/pathset.sh /etc/profile.d/
}

clear
printf "Thank you for downloading Carter's auto installer.\nThis is to be ran on a fresh install of Arch Linux on your user account.\nOver 10GB of data will be downloaded, most of it will be deleted after installation, however it will take a while.\nIf you do not wish to proceed, press Ctrl+C\nYou will shortly be prompted for your sudo password.\nPress enter to begin:\n"
read

mkdir -pv ~/.local/src
clear

# Disable sudo timeout
sudo echo "Authenticated"
while :; do sudo -v; sleep 59; done &
sleep 2

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
backgroundinstall
metropolisinstall
postinstall

clear
printf "Installation is now complete.\nYour computer will now reboot. To begin, login if you are in a tty or select dwm in your login manager.\nPress enter to reboot:\n"
read

rm -fr ~/installer.sh
sudo reboot
