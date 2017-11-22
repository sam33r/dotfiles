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
  sudo apt-get update && time sudo apt-get dist-upgrade
  while IFS=, read package description
  do
    printf "\n\n\n$package : $description\n\n"
    yes | sudo apt-get install $package
  done < $dir/$packages_list
}

function custom_install_esoteric_packages()                                      # Packages and crap only needed for custom hardware
{
  sudo add-apt-repository ppa:graphics-drivers/ppa
  sudo add-apt-repository ppa:lexical/hwe-wireless

  sudo apt-get install broadcom-sta-dkms
  sudo apt-get install nvidia-370
}

function install_dotfiles()
{
  while IFS=, read config_path dotfile_path
  do
    printf "\n\n"
    # Expand any env variables in the config.
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

function install_pips()                                                          # virtual envs for pip, and packages
{
  sudo easy_install pip
  sudo pip install --upgrade virtualenv

  if [ ! -d "$HOME/pyenv" ]; then
    virtualenv $HOME/pyenv
  fi

  if [ ! -d "$HOME/py3env" ]; then
    virtualenv -p python3 $HOME/py3env
  fi
  $HOME/pyenv/bin/pip install urllib3[secure]
  $HOME/pyenv/bin/pip install --upgrade howdoi

  $HOME/pyenv/bin/pip install --upgrade i3ipc
  $HOME/py3env/bin/pip3 install --upgrade i3ipc

  $HOME/pyenv/bin/pip install --upgrade vobject parsedatetime
  $HOME/pyenv/bin/pip install --upgrade gcalcli

  $HOME/py3env/bin/pip3 install --upgrade youtube_dl
  $HOME/py3env/bin/pip3 install --upgrade mps-youtube

  $HOME/pyenv/bin/pip install --upgrade Pygments
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

function install_update_liquidprompt()                                           # Install liquidprompt, outstanding bash prompt.
{
  cd $HOME
  git clone https://github.com/nojhan/liquidprompt.git
  cd liquidprompt
  git pull origin master
  source liquidprompt
  cd $dir
}

function install_update_z()
{
  cd $HOME
  git clone https://github.com/rupa/z.git
  cd z/
  git pull origin master
  cd $dir
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

  cd $HOME
  git clone https://github.com/powerline/fonts.git plfonts
  cd plfonts
  . ./install.sh
  cd $HOME
  yes | rm -R plfonts

  cd $HOME
  mkdir tmp_input
  # Download and put the font in a local dir.
  wget "http://input.fontbureau.com/build/?fontSelection=fourStyleFamily&regular=InputMono-Regular&italic=InputMono-Italic&bold=InputMono-Bold&boldItalic=InputMono-BoldItalic&a=0&g=ss&i=serif&l=serifs_round&zero=slash&asterisk=height&braces=straight&preset=dejavu&line-height=1.3&accept=I+do&email=" -O tmp_input/font.zip
  unzip tmp_input/font.zip -d $HOME/tmp_input
  sudo mkdir -p /usr/share/fonts/truetype/input
  sudo cp $HOME/tmp_input/Input_Fonts/Input/*  /usr/share/fonts/truetype/input/
  rm -R tmp_input

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

  echo "Installing version 0.9.18. Check https://github.com/djcb/mu/releases"
  echo "for newer versions."

  sudo apt-get install libgmime-2.6-dev

  wget -O "$HOME/Downloads/mu.tar.gz" \
      "https://github.com/djcb/mu/releases/download/0.9.18/mu-0.9.18.tar.gz"
  cd $HOME/Downloads
  tar xvfz mu.tar.gz
  cd "mu-0.9.18"
  ./configure && make
  sudo make install

  cd ..
  rm -Rf "mu-0.9.18"
  rm -f mu.tar.gz
  cd $dir
}

function install_nvim_from_source()
{
  # install build prerequisites
  sudo apt-get install libtool autoconf automake cmake g++ pkg-config python-pip python-dev

  # build
  cd ~/tmp
  # The latest release as of Nov 2017 is v0.2.2. Verify that it is still the
  # case at https://github.com/neovim/neovim/releases/latest, and change the
  # --branch flag if there is a new release.
  git clone --branch v0.2.2 https://github.com/neovim/neovim.git
  cd neovim
  make install CMAKE_EXTRA_FLAGS=-DCMAKE_INSTALL_PREFIX=$HOME/.local CMAKE_BUILD_TYPE=Release

  # In order to run Python plugins, you need the neovim Python library
  pip2 install --user neovim

  # Symlink vim configs to nvim locations
  ln -s ~/.vim ~/.config/nvim
  ln -s ~/.vimrc ~/.config/nvim/init.vim

  cd $dir
}

function custom_install_i3gaps()
{
  cd $HOME

  # TODO: Maybe use https://github.com/maestrogerardo/i3-gaps-deb
  echo "This assumes dependencies are installed."
  echo "See https://github.com/Airblader/i3/wiki/Compiling-&-Installing"

  # clone the repository
  git clone https://www.github.com/Airblader/i3 i3-gaps
  cd i3-gaps
  git pull origin master

  # compile & install
  autoreconf --force --install
  rm -rf build/
  mkdir -p build && cd build/

  # Disabling sanitizers is important for release versions!
  # The prefix and sysconfdir are, obviously, dependent on the distribution.
  ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
  make
  sudo make install

  cd $dir
}

function install_update_antigen()
{
  curl -L git.io/antigen > $HOME/.antigen.zsh
}

function theme()                                                                 # Change Gnome Terminal theme.
{
  wget -O xt  http://git.io/vGz67 && chmod +x xt && ./xt && rm xt
}

function update_hosts()                                                          # Update the system hosts file (Via StevenBlack/hosts)
{
  sudo python $HOME/hosts/updateHostsFile.py --extensions fakenews \
      gambling porn
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

function tiny_install()                                                          # Do a tiny install of command line editing tools for servers etc.
{
  # Add support for installing external repositories.
  sudo apt-get install software-properties-common

  # Add emacs from a pre-built stable release.
  # NOTE: This can go away when universal has emacs25.
  sudo add-apt-repository ppa:kelleyk/emacs
  sudo apt-get update
  sudo apt-get install emacs25

  sudo apt-get install vim openssl
  install_update_vim_plugins
  install_update_liquidprompt
  install_update_spacemacs
  install_update_transcrypt

  install_dotfiles
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
  cd $dir
  "$@"
fi
