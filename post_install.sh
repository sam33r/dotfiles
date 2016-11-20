#!/bin/bash

# Post-install setup. This script is called by install.sh
# Append lines to this file for any post-installation
# tasks, like cloning git packages or installing applications
# not available via package manager.


# If a command is globally applicable, enter it as-is in this
# file. If it needs user confirmation, use the confirm() util
# function.

# Utility function to confirm a command before running it.
confirm() {
  printf "\n\n" 
  echo -n "Do you want to run $*? [y/n] " </dev/tty
  read -N 1 REPLY
  echo
  if test "$REPLY" = "y" -o "$REPLY" = "Y"; then
    "$@"
  else
    echo "Skipping"
  fi
}

cd

# Install howdoi
confirm pip install howdoi

# Install liquidprompt
confirm git clone https://github.com/nojhan/liquidprompt.git

confirm git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
confirm vim +PluginInstall +qall

# Bind neovim to vim configs.
ln -s $HOME/.vim $HOME/.config/nvim
ln -s $HOME/.vimrc $HOME/.config/nvim/init.vim

# Install playerctl from github
install_playerctl() {
  # This retrieves download link of latest release.
  dlink=`curl -s https://api.github.com/repos/acrisci/playerctl/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4`
  dpath="$HOME/Downloads/playerctl.deb"
  wget -O $dpath $dlink
  sudo dpkg -i $dpath
  sudo apt-get install -f
  rm -f $dpath
}
confirm install_playerctl

# Install spotify (requires adding spotify repository)
install_spotify() {
  # 1. Add the Spotify repository signing key 
  #to be able to verify downloaded packages
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
  # 2. Add the Spotify repository
  echo deb http://repository.spotify.com stable non-free | sudo tee \
    /etc/apt/sources.list.d/spotify.list
  # 3. Update list of available packages
  sudo apt-get update
  # 4. Install Spotify
  sudo apt-get install spotify-client
}
confirm install_spotify

install_arc_theme_ubuntu_1604_only() {
	sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
	sudo apt-get update
	sudo apt-get install arc-theme
  gsettings set org.gnome.desktop.interface gtk-theme Arc-Darker
}
confirm install_arc_theme_ubuntu_1604_only

install_fonts() {
  wget -O $HOME/.fonts/"System San Francisco Display Bold.ttf" https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Bold.ttf
  wget -O $HOME/.fonts/"System San Francisco Display Regular.ttf" https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Regular.ttf
  wget -O $HOME/.fonts/"System San Francisco Display Thin.ttf" https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Thin.ttf
  wget -O $HOME/.fonts/"System San Francisco Display Ultralight.ttf" https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Ultralight.ttf
}
confirm install_fonts
  
# Set system preferences. 
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set com.canonical.desktop.interface scrollbar-mode normal
