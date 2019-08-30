#!/bin/bash

#--------------------------------------------------------------------------------
# Configuration Variables
#--------------------------------------------------------------------------------

# Where to backup any existing dotfiles before linking to new
# dotfiles.
backup_dir=$HOME/dotfiles_backup/`date +%s`

# dotfiles config file.
# This is a dumber-than-csv file, each line should be of the form
# <Original Config File Path>,<Path within the ${dir} directory>
dotfiles_list="dotfiles.csv"

# List of packages to install.
# Each line should be of the format <package_name>,<description>
packages_list="packages.csv"
#--------------------------------------------------------------------------------

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#--------------------------------------------------------------------------------
# Configuration Functions
#--------------------------------------------------------------------------------
# Add new configuration operations here as functions.
# Rules of engagement:
# - Each function should be idempotent and avoid any side effects.
# - No params allowed.
# - Can assume that it is run within the context of $dir.
# - Installation functions that should be run at least once on a new install
#   should have the "install_" prefix.
#--------------------------------------------------------------------------------

function install_update_packages()
{
  sudo apt-get update
  sudo apt-get dist-upgrade
  while IFS=, read package description
  do
    printf "\n\n\n$package : $description\n\n"
    yes | sudo apt-get install $package
  done < $dir/$packages_list
  sudo apt-get autoremove
  sudo apt-get autoclean
  sudo apt-get clean
}

function custom_install_esoteric_packages()                                      # Packages and crap only needed for custom hardware
{
  sudo add-apt-repository ppa:graphics-drivers/ppa
  sudo add-apt-repository ppa:lexical/hwe-wireless

  sudo apt-get install broadcom-sta-dkms
  sudo apt-get install nvidia-370
}

# TODO: Just use stow.
function install_dotfiles()
{
  while IFS=, read config_path dotfile_path
  do
    printf "\n\n"
    cpath=$(eval echo $config_path)
    dpath=$(eval echo $dotfile_path)

    printf "\n${cpath}"
    printf "\n ⇒ ${backup_dir}"
    mv "${cpath}" "${backup_dir}"/"${dpath}" 2>/dev/null
    printf "\n ← ${dir}/${dpath}\n"
    mkdir -p `dirname ${cpath}`
    ln -fs "${dir}"/"${dpath}" "${cpath}"
  done < $dir/$dotfiles_list
}

# TODO: Just use stow.
function install_some_dotfiles()
{
  while IFS=, read config_path dotfile_path
  do
    printf "\n\n"
    # Expand any env variables in the config.
    cpath=$(eval echo $config_path)
    dpath=$(eval echo $dotfile_path)

    echo "${dir}/${dpath} ⇒ ${cpath}"
    read -p "Do this? (y/n)" answer </dev/tty
    if echo "$answer" | grep -iq "^n" ;then
      echo "Skipped."
      continue
    fi

    mv "${cpath}" "${backup_dir}"/"${dpath}" 2>/dev/null
    mkdir -p `dirname ${cpath}`
    ln -fs "${dir}"/"${dpath}" "${cpath}"
    echo "Moved."
  done < $dir/$dotfiles_list
}

function install_fbterm()
{
  sudo apt-get install fbterm fbset
  # Add current user to the video group.
  sudo gpasswd -a $USER video
  sudo chmod u+s /usr/bin/fbterm
}

function install_indicator_kdeconnect_from_source()
{
  cd $HOME
  # A recent fork that fixes the issue with kdeconnect icon not showing in system tray.
  git clone https://github.com/Bajoja/indicator-kdeconnect
  cd indicator-kdeconnect
  git pull origin master
  sudo apt install libgtk-3-dev
  sudo apt install libappindicator3-dev
  sudo apt install cmake
  sudo apt install valac
  sudo apt install libgee-0.8-dev
  sudo apt install libjson-glib-dev
  sudo apt install python3-requests-oauthlib
  sudo apt install kde-cli-tools
  sudo apt install python-nautilus
	mkdir build
	cd build
	meson .. --prefix=/usr/  --libdir=/usr/lib/
	meson configure -Dextensions=python
	ninja
	ninja install
  cd $dir
}

function install_rclone()
{
  curl https://rclone.org/install.sh | sudo bash
}

function install_emacs_from_source()
{
  cd $HOME

  # Install necessary packages.
  sudo apt install autoconf automake libtool texinfo build-essential \
    xorg-dev libgtk2.0-dev libjpeg-dev libncurses5-dev libdbus-1-dev \
    libgif-dev libtiff-dev libm17n-dev libpng-dev librsvg2-dev \
    libotf-dev libgnutls28-dev libxml2-dev


  git clone https://github.com/mirrors/emacs.git
  cd ~/emacs
  # discard stuff from last build
  git reset --hard
  # delete all of the last build stuff
  git clean -xdf

  git fetch --all
  git pull origin master
  tag=$(git tag | rofi -dmenu -p "Which Tag? " -padding 100 -only-match)
  git checkout tags/$tag

  ./autogen.sh
  ./configure
  make bootstrap
  make

  cd $dir
}

function install_scrcpy_from_source()
{
  cd $HOME

  # runtime dependencies
  sudo apt install ffmpeg libsdl2-2.0.0

  # client build dependencies
  sudo apt install make gcc pkg-config meson \
       libavcodec-dev libavformat-dev libavutil-dev \
       libsdl2-dev

  # server build dependencies
  sudo apt install openjdk-8-jdk

  git clone https://github.com/Genymobile/scrcpy
  cd scrcpy
  git pull origin master

  # This only works if $ANDROID_HOME is set.
  meson x --buildtype release --strip -Db_lto=true
  cd x
  ninja
  sudo ninja install
  cd $dir
}

function install_tmux_persist()
{
  cd $HOME
  git clone https://github.com/sam33r/tmux-persist
  cd tmux-persist
  git pull origin master
  cd $dir
}

function install_update_cargo_rust()
{
  if (which rustup); then
    rustup update
  else
    sudo /usr/local/lib/rustlib/uninstall.sh
    curl https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env
  fi
}

function install_fd()
{
  install_update_cargo_rust
  cargo install fd-find
}

function install_kitty()
{
  install_update_cargo_rust
  cd $HOME
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  cd $dir
}

function install_alacritty()
{
  cd $HOME
  git clone https://github.com/jwilm/alacritty.git
  cd alacritty
  git pull origin master
  cargo install cargo-deb
  cargo deb --install
  cd $dir
}

function install_git_gnome_support() {
  sudo apt-get install libsecret-1-0 libsecret-1-dev
  cd /usr/share/doc/git/contrib/credential/libsecret
  sudo make
  git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
}

function install_pips()                                                          # virtual envs for pip, and packages
{
  sudo easy_install pip
  sudo pip install --upgrade pip
  sudo pip install --upgrade virtualenv

  if [ ! -d "$HOME/py3env" ]; then
    virtualenv -p python3 $HOME/py3env
  fi

  $HOME/py3env/bin/pip3 install --upgrade pip

  $HOME/py3env/bin/pip3 install urllib3[secure]
  $HOME/py3env/bin/pip3 install --upgrade howdoi
  $HOME/py3env/bin/pip3 install --upgrade youtube_dl
  $HOME/py3env/bin/pip3 install --upgrade mps-youtube
  # Packages used by ~/hosts
  $HOME/py3env/bin/pip3 install --upgrade lxml bs4
}

function install_update_vim_plugins()
{
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
  vim +PluginInstall! +qall
}

function install_copyq()                                             # Install copyq clipboard manager.
{
  cd $HOME
  sudo apt install \
    git cmake \
    qtbase5-private-dev \
    qtscript5-dev \
    qttools5-dev \
    qttools5-dev-tools \
    libqt5svg5-dev \
    libxfixes-dev \
    libxtst-dev \
    libqt5svg5
  git clone https://github.com/hluk/CopyQ.git
  cd CopyQ
  git pull origin master
  cmake -DCMAKE_INSTALL_PREFIX=/usr/local .
  make
  sudo make install
  cd $dir
}

function install_dwm()
{
  cd $HOME
  git clone https://github.com/sam33r/dwm
  cd dwm
  sudo apt-get update
  sudo apt-get install build-essential libx11-dev libxinerama-dev sharutils \
      libxft-dev
  make
  sudo make install
  cd $dir
  cat >/tmp/dwm.desktop <<EOL
[Desktop Entry]
Name=dwm
Comment=dynamic window manager
Exec=dwm
TryExec=dwm
Type=Application
X-LightDM-DesktopName=dwm
DesktopNames=dwm
EOL
  sudo cp -f /tmp/dwm.desktop /usr/share/xsessions/dwm.desktop
  sudo chmod a+r /usr/share/xsessions/dwm.desktop
  cat /usr/share/xsessions/dwm.desktop
}

function install_st()
{
  cd $HOME
  git clone https://github.com/sam33r/st
  cd st
  make
  sudo make install
  cd $dir
}

function install_fpp()                                                           # Install FB Path Picker
{
  cd $HOME
  git clone https://github.com/facebook/PathPicker.git
  cd PathPicker/
  git pull origin master
  mkdir -p $HOME/bin
  ln -s "$(pwd)/fpp" $HOME/bin/fpp
  fpp --help
  cd $dir
}

function install_update_fasd()
{
  cd $HOME
  git clone https://github.com/clvv/fasd
  cd fasd
  git pull origin master
  PREFIX=$HOME make install
  cd $dir
}

function install_update_spacevim()
{
  cd $HOME
  curl -sLf https://spacevim.org/install.sh | bash
}

function install_update_liquidprompt()                                           # Install liquidprompt, outstanding bash prompt.
{
  cd $HOME
  git clone https://github.com/nojhan/liquidprompt.git
  cd liquidprompt
  git pull origin master
  source liquidprompt
  cd $dir
}

function install_youtube_dl()                                                    # Install global youtube-dl command.
{
  sudo curl -L https://yt-dl.org/latest/youtube-dl -o /usr/local/bin/youtube-dl
  sudo chmod a+rx /usr/local/bin/youtube-dl
}

function install_update_fzf()                                                    # Install fzf for command searches.
{
  if type "fzf" > /dev/null; then
    echo "fzf already exists, updating."
    cd $HOME/.fzf
    git pull origin master
    cd $dir
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  fi
  $HOME/.fzf/install
}

function install_keybase()
{
  cd $HOME
  curl -O https://prerelease.keybase.io/keybase_amd64.deb
  # if you see an error about missing `libappindicator1`
  # from the next command, you can ignore it, as the
  # subsequent command corrects it
  sudo dpkg -i keybase_amd64.deb
  sudo apt-get install -f
  run_keybase
  cd $dir
}

function install_playerctl()                                                     # PlayerCTL provides command-line tools to manage media playback.
{
  # This retrieves download link of latest release.
  dlink=`curl -s https://api.github.com/repos/acrisci/playerctl/releases \
              | grep browser_download_url | head -n 1 | cut -d '"' -f 4`
  dpath="$HOME/Downloads/playerctl.deb"
  wget -O $dpath $dlink
  sudo dpkg -i $dpath
  sudo apt-get install -f
  rm -f $dpath
}

function install_googler()                                                       # Command-line tool to query google.
{
  cd $HOME
  git clone https://github.com/jarun/googler
  cd googler
  git pull origin master
  sudo make install
}

function custom_install_emacs_snapshot()                                         # Install emacs nightly snapshots.
{
  sudo add-apt-repository ppa:ubuntu-elisp/ppa
  sudo apt-get update
  sudo apt-get install emacs-snapshot
  sudo update-alternatives --config emacs
}

function custom_install_arc_theme_ubuntu_1604_only()                             # Install gnome theme of choice.
{
  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/arc-theme.list"
  sudo apt-get update
  sudo apt-get install arc-theme
  gsettings set org.gnome.desktop.interface gtk-theme Arc-Darker
}

function install_rofi_manually()                                                 # install rofi manually (not available on apt-get in 14.04)
{
  if type "rofi" > /dev/null; then
    echo "rofi already exists"
    return
  fi
  # install deps.
  yes | sudo apt-get install libxinerama-dev libxft2 libpango1.0-dev \
             libpangocairo-1.0-0 libcairo2-dev libglib2.0-dev libx11-dev \
             libstartup-notification0-dev libxkbcommon-dev libxkbcommon-x11-dev \
             libxcb1-dev libx11-xcb-dev libxcb-ewmh-dev libxcb-icccm4-dev \
             libxcb-util0-dev libxcb-xinerama0-dev
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

function install_i3blocks_manually()                                             # install i3blocks manually (not available on apt-get in 14.04)
{
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

function install_update_fonts()                                                  # Install fonts, including powerline.
{
  mkdir -p $HOME/.fonts

  # Install San Francisco.
  git clone https://github.com/supermarin/YosemiteSanFranciscoFont.git \
      $HOME/.fonts/san-francisco
  cd $HOME/.fonts/san-francisco
  git pull origin master

  # Install ET Book.
  cd $HOME
  git clone https://github.com/edwardtufte/et-book.git \
      $HOME/.fonts/et-book
  cd $HOME/.fonts/et-book
  git pull origin master

  cd $HOME
  git clone https://github.com/powerline/fonts.git plfonts
  cd plfonts
  . ./install.sh
  cd $HOME
  yes | rm -R plfonts

  # Install Input
  cd $HOME
  mkdir tmp_input
  wget "http://input.fontbureau.com/build/?fontSelection=fourStyleFamily&regular=InputMono-Regular&italic=InputMono-Italic&bold=InputMono-Bold&boldItalic=InputMono-BoldItalic&a=0&g=ss&i=serif&l=serifs_round&zero=slash&asterisk=height&braces=straight&preset=dejavu&line-height=1.3&accept=I+do&email=" -O tmp_input/font.zip
  yes | unzip tmp_input/font.zip -d $HOME/tmp_input
  sudo mkdir -p /usr/share/fonts/truetype/input
  sudo cp $HOME/tmp_input/Input_Fonts/Input/*  /usr/share/fonts/truetype/input/
  rm -R tmp_input

  # Install Open Sans, Merriweather, Source Sans Pro and Libre Baskerville
  cd $HOME
  git clone https://github.com/google/fonts /tmp/google-fonts --depth 1
  mkdir -p $HOME/.fonts/open-sans
  cp /tmp/google-fonts/apache/opensans/* $HOME/.fonts/open-sans
  mkdir -p $HOME/.fonts/merriweather
  cp /tmp/google-fonts/ofl/merriweather/* $HOME/.fonts/merriweather
  mkdir -p $HOME/.fonts/sourcesanspro
  cp /tmp/google-fonts/ofl/sourcesanspro/* $HOME/.fonts/sourcesanspro
  mkdir -p $HOME/.fonts/nunito
  cp /tmp/google-fonts/ofl/nunito/* $HOME/.fonts/nunito
  mkdir -p $HOME/.fonts/librebaskerville
  cp /tmp/google-fonts/ofl/librebaskerville/* $HOME/.fonts/librebaskerville

  yes | rm -R /tmp/google-fonts

  sudo fc-cache -f -v
  cd $dir
}

function install_update_spacemacs()
{
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
  cd ~/.emacs.d
  git pull origin master
  cd $dir
}

function install_mu4e_from_tarball()                                             # Install mu4e from github tarball (apt version is too old).
{
  if type "mu" > /dev/null; then
    echo "mu already exists"
    echo -n "Do you still want to run this? (y/n) "
    read answer
    if echo "$answer" | grep -iq "^n" ;then
      return
    fi
  fi

  echo "Installing version 1.2. Check https://github.com/djcb/mu/releases"
  echo "for newer versions."

  sudo apt-get install libgmime-3.0-dev

  wget -O "$HOME/Downloads/mu.tar.xz" \
      "https://github.com/djcb/mu/releases/download/1.2/mu-1.2.0.tar.xz"
  cd $HOME/Downloads
  tar -xf mu.tar.xz
  cd "mu-1.2.0"
  ./configure && make
  sudo make install

  cd ..
  rm -Rf "mu-1.2.0"
  rm -f mu.tar.xz
  cd $dir
}

function install_nvim_from_source()
{
  # install build prerequisites
  sudo apt-get install libtool autoconf automake cmake g++ pkg-config python-pip python-dev

  # build
  cd /tmp
  # The latest release as of Nov 2017 is v0.2.2. Verify that it is still the
  # case at https://github.com/neovim/neovim/releases/latest, and change the
  # --branch flag if there is a new release.
  git clone --branch v0.2.2 https://github.com/neovim/neovim.git
  cd neovim
  make install CMAKE_EXTRA_FLAGS=-DCMAKE_INSTALL_PREFIX=$HOME/.local CMAKE_BUILD_TYPE=Release

  # In order to run Python plugins, you need the neovim Python library
  pip2 install --user neovim

  # Symlink vim configs to nvim locations
  ln -s -f ~/.vim ~/.config/nvim
  ln -s -f ~/.vimrc ~/.config/nvim/init.vim

  cd $dir
}

function install_tmux_plugins()
{
  cd $HOME
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  cd $dir
  # TODO: Find shell alternative of <Ctrl+a> I to to install
  # plugins.
}

function install_tmux_from_source()
{
  cd $HOME
  git clone https://github.com/tmux/tmux.git
  cd tmux
  git pull origin master
  sudo apt-get install libevent-dev libncurses5-dev libncursesw5-dev
  sh autogen.sh
  ./configure && make
  sudo make install

  install_tmux_plugins
}

function install_update_antigen()
{
  curl -L git.io/antigen > $HOME/antigen.zsh
}

function update_hosts()                                                          # Update the system hosts file (Via StevenBlack/hosts)
{
  cd $HOME
  git clone https://github.com/StevenBlack/hosts.git
  cd hosts
  git pull origin master
  sudo ~/py3env/bin/python3 updateHostsFile.py \
    --backup \
    --flush-dns-cache \
    --extensions fakenews gambling porn
  cd $dir
}

function set_gnome_preferences()
{
  gsettings set org.gnome.desktop.background show-desktop-icons false
  gsettings set com.canonical.desktop.interface scrollbar-mode normal
  gsettings set org.gnome.desktop.interface cursor-size 48
}

function dotify()                                                                # Move an existing dotfile to this project.
{
  set -e

  echo "Enter source file path (relative to $HOME):"
  printf $HOME/
  read src_path

  echo "Enter destination path:"
  printf $dir/
  read dest_path

  echo "Moving $HOME/$src_path to $dir/$dest_path"

  mkdir -p `dirname $dir/$dest_path`
  mv $HOME/$src_path $dir/$dest_path

  echo "Adding to dotfiles config"
  echo \$HOME/$src_path,$dest_path >> $dir/dotfiles.csv

  sort $dir/$dotfiles_list -o $dir/$dotfiles_list


  echo "Linking $HOME/$src_path to $dir/$dest_path"
  ln -fs $dir/$dest_path $HOME/$src_path

  echo "Done."
}

function add_package()                                                           # Install a package and add it to the package list
{
  set -e

  echo "Package: "
  read package

  printf "\n\n"

  echo "Purpose: "
  read description

  sudo apt-get install $package

  echo "Installed package, now adding to registry."
  echo "$package,$description" >> $dir/$packages_list
  sort $dir/$packages_list -o $dir/$packages_list

  echo "Done."
}

function edit()
{
  vim $0
}

function edit_packages()                                                         # Edit the packages list.
{
  vim $dir/$packages_list
}

function edit_dotfiles()                                                         # Edit the dotfiles list.
{
  vim $dir/$dotfiles_list
}

# -------------------------------------------------------------------------------
# Docker Functions:
# Experimenting with using docker to load tui/gui apps.
# -------------------------------------------------------------------------------
function htop()                                                                  # Run htop
{
  docker run --rm -it --pid host jess/htop
}

function docker_cleanup()
{
	local containers
	containers=( $(docker ps -aq 2>/dev/null) )
	docker rm "${containers[@]}" 2>/dev/null
	local volumes
	volumes=( $(docker ps --filter status=exited -q 2>/dev/null) )
	docker rm -v "${volumes[@]}" 2>/dev/null
	local images
	images=( $(docker images --filter dangling=true -q 2>/dev/null) )
	docker rmi "${images[@]}" 2>/dev/null
}

function setup_termux()
{
	pkg install termux-api curl tmux python man vim emacs
	install_dotfiles
	install_tmux_plugins
	install_update_vim_plugins
	install_update_spacemacs

  echo "Email for global git: "
  read git_email
  echo "Name for global git: "
  read git_name
  git config --global user.email $git_email
  git config --global user.name $git_name
}

#--------------------------------------------------------------------------------
# Common functions (Don't change)
#--------------------------------------------------------------------------------

function everystall()                                                            # Run all installation functions.
{
  install_fns=`awk '/^function install_/{ print substr($2, 1, length($2) - 2)}' $0`
  printf "The following functions will be run, in the order specified here:"
  printf "\n\n$install_fns\n\n"

  for install_fn in $install_fns
  do
    printf "\n\n$install_fn\n\n"
    echo -n "Run this? (y/n) "
    read answer
    if echo "$answer" | grep -iq "^n" ;then
      continue
    fi
    cd $dir
    $install_fn
    printf "\n\n"
  done
}

function help()
{
  printf "\n"
  echo "Usage: do <function>"
  printf "\n"
  echo "Valid functions:"
  printf "\n"
  awk '/^function /{s = ""; for (i = 4; i <= NF; i++) s = s $i " "; printf("%40s   %s\n",substr($2, 1, length($2) - 2), s)}' $0
}

if [ "_$1" = "_" ]; then
  help
else
  mkdir -p ${backup_dir}
  cd $dir
  "$@"
fi
