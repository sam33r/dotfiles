#!/bin/bash

# Post-install setup. This script is called by install.sh
# Append lines to this file for any post-installation
# tasks, like cloning git packages or installing applications
# not available via package manager.

# Directory of this project.
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $dir/config.sh
cd $dir

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

# Install howdoi
confirm sudo pip install howdoi

# Install jrnl
confirm sudo pip install jrnl[encrypted]

# Install liquidprompt
install_update_liquidprompt() {
  cd $HOME
  git clone https://github.com/nojhan/liquidprompt.git
  cd liquidprompt
  git pull origin master
  cd $dir
}
confirm install_update_liquidprompt

confirm git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
confirm vim +PluginInstall! +qall

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

# install/upgrade psutil (used by glances)
confirm sudo pip install psutil --upgrade
# Install googler (command-line google search)
# TODO: Common function for installing non-standard packages
# from github.
install_googler() {
  # This retrieves download link of latest release.
  dlink=`curl -s https://api.github.com/repos/jarun/googler/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4`
  dpath="$HOME/Downloads/googler.deb"
  wget -O $dpath $dlink
  sudo dpkg -i $dpath
  sudo apt-get install -f
  rm -f $dpath
}
confirm install_googler

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
  yes | sudo apt-get install spotify-client
}
confirm install_spotify

install_arc_theme_ubuntu_1604_only() {
  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
  sudo apt-get update
  sudo apt-get install arc-theme
  gsettings set org.gnome.desktop.interface gtk-theme Arc-Darker
}
confirm install_arc_theme_ubuntu_1604_only

# install rofi manually (not available on apt-get in 14.04)
install_rofi_manually() {
  if type "rofi" > /dev/null; then
    echo "rofi already exists"
    return
  fi
  # install deps.
  yes | sudo apt-get install libxinerama-dev libxft2 libpango1.0-dev libpangocairo-1.0-0 libcairo2-dev libglib2.0-dev libx11-dev libstartup-notification0-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb1-dev libx11-xcb-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-util0-dev libxcb-xinerama0-dev
  wget https://github.com/DaveDavenport/rofi/releases/download/1.1.0/rofi-1.1.0.tar.gz -O $HOME/rofi.tgz
  cd $HOME
  tar xvzf rofi.tgz
  cd $HOME/rofi*
  ./configure
  make
  sudo make install
  cd $dir
  rm -rf $HOME/rofi*
}
confirm install_rofi_manually

# install i3blocks manually (not available on apt-get in 14.04)
install_i3blocks_manually() {
  if type "i3blocks" > /dev/null; then
    echo "i3blocks already exists"
    return
  fi
  cd $HOME
  git clone https://github.com/vivien/i3blocks.git
  cd i3blocks
  make clean all
  sudo make install
  cd $HOME
  rm -rf i3blocks
  cd $dir
}
confirm install_i3blocks_manually

install_fonts() {
  mkdir -p $HOME/.fonts
  wget -O $HOME/.fonts/"System San Francisco Display Bold.ttf" https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Bold.ttf
  wget -O $HOME/.fonts/"System San Francisco Display Regular.ttf" https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Regular.ttf
  wget -O $HOME/.fonts/"System San Francisco Display Thin.ttf" https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Thin.ttf
  wget -O $HOME/.fonts/"System San Francisco Display Ultralight.ttf" https://github.com/supermarin/YosemiteSanFranciscoFont/raw/master/System%20San%20Francisco%20Display%20Ultralight.ttf
}
confirm install_fonts

# Set system preferences.
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set com.canonical.desktop.interface scrollbar-mode normal
