#!/bin/bash

#--------------------------------------------------------------------------------
# Configuration Variables
#--------------------------------------------------------------------------------

# Where to backup any existing dotfiles before linking to new
# dotfiles.
backup_dir=$HOME/dotfiles_backup/$(date +%s)

# dotfiles config file.
# This is a dumber-than-csv file, each line should be of the form
# <Original Config File Path>,<Path within the ${dir} directory>
dotfiles_list="dotfiles.csv"

# List of packages to install.
# Each line should be of the format <package_name>,<description>
packages_list="packages.csv"
#--------------------------------------------------------------------------------

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

src_dir="$HOME/src"
mkdir -p $src_dir

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

function prompt_user() {
  while true; do
    read -p "$1" yn
    case $yn in
    [Yy]*)
      return "true"
      ;;
    [Nn]*)
      return "false"
      ;;
    *) echo "Please answer yes or no." ;;
    esac
  done
}

function install_dwm_from_src() {
  cd $src_dir
  git clone https://github.com/sam33r/dwm
  cd dwm
  sudo apt-get update
  sudo apt-get install build-essential libx11-dev libxinerama-dev sharutils \
    libxft-dev
  make
  sudo make install
  cd $dir
  cat >/tmp/startdwm <<EOL
#!/bin/sh
dbus-launch --sh-syntax --exit-with-session dwm
EOL
  sudo cp -f /tmp/startdwm /usr/local/bin/startdwm
  sudo chmod a+x /usr/local/bin/startdwm

  cat >/tmp/dwm.desktop <<EOL
[Desktop Entry]
Name=dwm
Comment=dynamic window manager
Exec=startdwm
Type=Application
X-LightDM-DesktopName=dwm
DesktopNames=dwm
EOL
  sudo cp -f /tmp/dwm.desktop /usr/share/xsessions/dwm.desktop
  sudo chmod a+r /usr/share/xsessions/dwm.desktop
  cat /usr/share/xsessions/dwm.desktop
}

function init_dotfiles() {
  while IFS=, read config_path dotfile_path; do
    printf "\n\n"
    cpath=$(eval echo $config_path)
    dpath=$(eval echo $dotfile_path)

    printf "\n${cpath}"
    printf "\n ⇒ ${backup_dir}"
    mv "${cpath}" "${backup_dir}"/"${dpath}" 2>/dev/null
    printf "\n ← ${dir}/${dpath}\n"
    mkdir -p $(dirname ${cpath})
    ln -fs "${dir}"/"${dpath}" "${cpath}"
  done <$dir/$dotfiles_list
}

function init_debian_desktop_environment() {
  echo "This function sets up the desktop environment."

  # dwm
  install_dwm_from_src

  # General X manipulation packages.
  sudo apt update
  sudo apt install \
    xautolock \
    xbacklight \
    xbindkeys \
    xbindkeys-config \
    xdotool \
    wmctrl \
    xinput \
    xnest \
    xprintidle \
    xtrace \
    compton \
    unclutter

  # goose

}

function init_debian_shell() {
  echo "This function sets up terminal environment and packages."

  sudo apt update
  sudo apt install \
    acpi \
    fdupes \
    gnupg2 \
    gnupg-agent \
    gocryptfs \
    howdoi \
    htop \
    inotify-tools \
    inxi \
    iotop \
    jq \
    lm-sensors \
    notmuch \
    offlineimap \
    pandoc \
    parallel \
    pdfgrep \
    pdftk \
    powertop \
    python3-pip \
    python-dev \
    rclone \
    remind \
    ripgrep \
    rlwrap \
    sqlite3 \
    stow \
    dmenu \
    tmux \
    vim \
    zsh

  # Other things to install from source.
  install_update_fasd_from_git
  install_update_liquidprompt_from_git
  install_update_fzf_from_git
  install_update_antigen_from_web
  install_tmux_persist_from_git

  p=$(prompt_user "Install tmux from source?")
  if [[ "$p" == "true" ]]; then
    install_update_tmux_from_src
  fi
  install_tmux_plugins_from_git

  p=$(prompt_user "Install rclone from rclone.org?")
  if [[ "$p" == "true" ]]; then
    install_rclone_from_rclone_org
  fi

  # Install Cargo packages.
  if (which rustup); then
    rustup update
  else
    sudo /usr/local/lib/rustlib/uninstall.sh
    curl https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env
  fi
  # fd (find alternative).
  cargo install fd-find

}

function init_emacs() {
  echo "emacs"

  # install emacs from source or package manager.
  # doom emacs
}

function init_desktop_software() {
  echo "software"
}

function install_update_apt_packages() {
  sudo apt-get update
  sudo apt-get dist-upgrade
  while IFS=, read package description; do
    printf "\n\n\n$package : $description\n\n"
    yes | sudo apt-get install $package
  done <$dir/$packages_list
  sudo apt-get autoremove
  sudo apt-get autoclean
  sudo apt-get clean
}

function custom_install_esoteric_apt_packages() { # Packages only needed for custom hardware
  # TODO: Move to device specific localdots.
  sudo add-apt-repository ppa:graphics-drivers/ppa
  sudo add-apt-repository ppa:lexical/hwe-wireless
  sudo apt-get install broadcom-sta-dkms
  sudo apt-get install nvidia-370
}

# Older (deprecated recipes) --------------------------------------------------------------

function install_apt_fbterm() {
  sudo apt-get install fbterm fbset
  # Add current user to the video group.
  sudo gpasswd -a $USER video
  sudo chmod u+s /usr/bin/fbterm
}

function install_apt_indicator_kdeconnect_from_source() {
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
  meson .. --prefix=/usr/ --libdir=/usr/lib/
  meson configure -Dextensions=python
  ninja
  ninja install
  cd $dir
}

function install_rclone_from_rclone_org() {
  curl https://rclone.org/install.sh | sudo bash
}

function install_apt_emacs_from_source() {
  cd $src_dir

  # Install necessary packages.
  sudo apt install autoconf automake libtool texinfo build-essential \
    xorg-dev libgtk2.0-dev libjpeg-dev libncurses5-dev libdbus-1-dev \
    libgif-dev libtiff-dev libm17n-dev libpng-dev librsvg2-dev \
    libotf-dev libgnutls28-dev libxml2-dev

  git clone --depth 1 https://github.com/mirrors/emacs.git
  cd emacs
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

function install_apt_scrcpy_from_source() {
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

function install_tmux_persist_from_git() {
  cd $HOME
  git clone https://github.com/sam33r/tmux-persist
  cd tmux-persist
  git pull origin master
  cd $dir
}

function install_update_cargo_rust_from_web() {
  if (which rustup); then
    rustup update
  else
    sudo /usr/local/lib/rustlib/uninstall.sh
    curl https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env
  fi
}

function install_fd_from_cargo() {
  install_update_cargo_rust
  cargo install fd-find
}

function install_brotab_from_pip() {
  pip3 install --upgrade brotab
  brotab install
}

function install_apt_git_gnome_support() {
  sudo apt-get install libsecret-1-0 libsecret-1-dev
  cd /usr/share/doc/git/contrib/credential/libsecret
  sudo make
  git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
}

function install_keepmenu_from_pip() {
  pip3 install --upgrade keepmenu
}

function install_pips_deprecated() { # virtual envs for pip, and packages
  sudo easy_install pip
  sudo pip install --upgrade pip
  sudo pip install --upgrade virtualenv
  sudo pip install --upgrade pyformat
  sudo pip install --upgrade python-flake8
  sudo pip install --upgrade functools32

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
  $HOME/py3env/bin/pip3 install --upgrade keepmenu
}

function install_update_vim_plugins_and_vundle() {
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
  vim +PluginInstall! +qall
}

function install_copyq_with_apt_deps() { # Install copyq clipboard manager.
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
    libqt5svg5 \
    libqt5x11extras5-dev
  git clone https://github.com/hluk/CopyQ.git
  cd CopyQ
  git pull origin master
  cmake -DCMAKE_INSTALL_PREFIX=/usr/local .
  make
  sudo make install
  cd $dir
}

function install_st_from_src() {
  cd $HOME
  git clone https://github.com/sam33r/st
  cd st
  make
  sudo make install
  cd $dir
}

function install_fpp_from_git() { # Install FB Path Picker
  cd $HOME
  git clone https://github.com/facebook/PathPicker.git
  cd PathPicker/
  git pull origin master
  mkdir -p $HOME/bin
  ln -s "$(pwd)/fpp" $HOME/bin/fpp
  fpp --help
  cd $dir
}

function install_update_fasd_from_git() {
  cd $src_dir
  git clone https://github.com/clvv/fasd
  cd fasd
  git pull origin master
  PREFIX=$HOME make install
  cd $dir
}

function install_update_spacevim_from_web() {
  cd $HOME
  curl -sLf https://spacevim.org/install.sh | bash
}

function install_update_liquidprompt_from_git() {
  cd $src_dir
  git clone https://github.com/nojhan/liquidprompt.git
  cd liquidprompt
  git pull origin master
  source liquidprompt
  cd $dir
}

function install_youtube_dl_from_web() { # Install global youtube-dl command.
  sudo curl -L https://yt-dl.org/latest/youtube-dl -o /usr/local/bin/youtube-dl
  sudo chmod a+rx /usr/local/bin/youtube-dl
}

function install_update_fzf_from_git() { # Install fzf for command searches.
  if type "fzf" >/dev/null; then
    echo "fzf already exists, updating."
    cd $HOME/.fzf
    git pull origin master
    cd $dir
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  fi
  $HOME/.fzf/install
}

function install_keybase_from_web_with_apt() {
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

function install_playerctl_from_web_with_apt() { # PlayerCTL provides command-line tools to manage media playback.
  # This retrieves download link of latest release.
  dlink=$(curl -s https://api.github.com/repos/acrisci/playerctl/releases |
    grep browser_download_url | head -n 1 | cut -d '"' -f 4)
  dpath="$HOME/Downloads/playerctl.deb"
  wget -O $dpath $dlink
  sudo dpkg -i $dpath
  sudo apt-get install -f
  rm -f $dpath
}

function install_googler_from_git() { # Command-line tool to query google.
  cd $HOME
  git clone https://github.com/jarun/googler
  cd googler
  git pull origin master
  sudo make install
}

function custom_install_emacs_snapshot_for_apt() { # Install emacs nightly snapshots.
  sudo add-apt-repository ppa:ubuntu-elisp/ppa
  sudo apt-get update
  sudo apt-get install emacs-snapshot
  sudo update-alternatives --config emacs
}

function fix_xbacklight_not_finding_devices() { # Fix xbacklight not finding devices to change brightness.
  # See https://unix.stackexchange.com/questions/301724/xbacklight-not-working
  backlight=$(ls /sys/class/backlight)
  echo "Find the right identifier:"
  xrandr --verbose | grep -B 1 Identifier
  echo "Identifier: "
  read identifier
  cat >/tmp/xorg.conf <<EOL
Section "Device"
    Identifier  "$identifier"
    Driver      "intel"
    Option      "Backlight"  "$backlight"
EndSection
EOL
  if [ -f "/etc/X11/xorg.conf" ]; then
    echo "Copy following to xorg.conf:"
    cat /tmp/xorg.conf
  else
    sudo cp /tmp/xorg.conf /etc/X11/
  fi
}

function install_rofi_from_web_with_apt() { # install rofi manually (not available on apt-get in 14.04)
  if type "rofi" >/dev/null; then
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

function install_i3blocks_from_web_with_apt() { # install i3blocks manually (not available on apt-get in 14.04)
  if type "i3blocks" >/dev/null; then
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

function install_update_fonts_from_web_and_git() { # Install fonts, including powerline.
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
  sudo cp $HOME/tmp_input/Input_Fonts/Input/* /usr/share/fonts/truetype/input/
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
  mkdir -p $HOME/.fonts/lexenddeca
  cp /tmp/google-fonts/ofl/lexenddeca/* $HOME/.fonts/lexenddeca
  mkdir -p $HOME/.fonts/literata
  cp /tmp/google-fonts/ofl/literata/* $HOME/.fonts/literata

  yes | rm -R /tmp/google-fonts

  sudo fc-cache -f -v
  cd $dir
}

function doom_refresh() {
  ~/.emacs.d/bin/doom refresh
}

function post_sync() {
  install_dotfiles
  install_update_fonts
  doom_refresh
}

function install_doom() {
  mv ~/.emacs.d ~/.emacs.d.old
  git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
  ~/.emacs.d/bin/doom install
}

function install_mu4e_from_web_with_apt() { # Install mu4e from github tarball (apt version is too old).
  if type "mu" >/dev/null; then
    echo "mu already exists"
    echo -n "Do you still want to run this? (y/n) "
    read answer
    if echo "$answer" | grep -iq "^n"; then
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

function install_tmux_plugins_from_git() {
  cd $HOME
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  cd $dir
  echo "Use <Ctrl+a> I in a tmux session to install and update plugins."
  # TODO: Find shell alternative of <Ctrl+a> I to to install
  # plugins.
}

function install_update_tmux_from_src() {
  cd $src_dir
  git clone https://github.com/tmux/tmux.git
  cd tmux
  git pull origin master
  sudo apt-get install libevent-dev libncurses5-dev libncursesw5-dev
  sh autogen.sh
  ./configure && make
  sudo make install
}

function install_update_antigen_from_web() {
  curl -L git.io/antigen >$HOME/antigen.zsh
}

function update_hosts_file() { # Update the system hosts file (Via StevenBlack/hosts)
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

function set_gnome_preferences() {
  gsettings set org.gnome.desktop.background show-desktop-icons false
  gsettings set com.canonical.desktop.interface scrollbar-mode normal
  gsettings set org.gnome.desktop.interface cursor-size 48
}

function dotify() { # Move an existing dotfile to this project.
  set -e

  echo "Enter source file path (relative to $HOME):"
  printf $HOME/
  read src_path

  echo "Enter destination path:"
  printf $dir/
  read dest_path

  echo "Moving $HOME/$src_path to $dir/$dest_path"

  mkdir -p $(dirname $dir/$dest_path)
  mv $HOME/$src_path $dir/$dest_path

  echo "Adding to dotfiles config"
  echo \$HOME/$src_path,$dest_path >>$dir/dotfiles.csv

  sort $dir/$dotfiles_list -o $dir/$dotfiles_list

  echo "Linking $HOME/$src_path to $dir/$dest_path"
  ln -fs $dir/$dest_path $HOME/$src_path

  echo "Done."
}

function add_apt_package() {
  set -e

  echo "Package: "
  read package

  printf "\n\n"

  echo "Purpose: "
  read description

  sudo apt-get install $package

  echo "Installed package, now adding to registry."
  echo "$package,$description" >>$dir/$packages_list
  sort $dir/$packages_list -o $dir/$packages_list

  echo "Done."
}

function edit() {
  vim $0
}

function edit_apt_packages() { # Edit the packages list.
  vim $dir/$packages_list
}

function edit_dotfiles() { # Edit the dotfiles list.
  vim $dir/$dotfiles_list
}

# -------------------------------------------------------------------------------
# Docker Functions:
# Experimenting with using docker to load tui/gui apps.
# -------------------------------------------------------------------------------
function htop() { # Run htop
  docker run --rm -it --pid host jess/htop
}

function docker_cleanup() {
  local containers
  containers=($(docker ps -aq 2>/dev/null))
  docker rm "${containers[@]}" 2>/dev/null
  local volumes
  volumes=($(docker ps --filter status=exited -q 2>/dev/null))
  docker rm -v "${volumes[@]}" 2>/dev/null
  local images
  images=($(docker images --filter dangling=true -q 2>/dev/null))
  docker rmi "${images[@]}" 2>/dev/null
}

function setup_termux_on_android() {
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

function install_update_grasp_from_git() {
  google-chrome
  cd $HOME
  git clone https://github.com/karlicoss/grasp
  cd grasp
  git pull origin master
}

function install_firefox_from_web() {
  cd $HOME
  wget -O ~/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
  tar xjf firefox.tar.bz2
  rm firefox.tar.bz2
  ln -fs ~/firefox/firefox ~/bin/firefox
}

function install_libinput_gestures_from_git_with_apt() { # Trackpad gestures.
  # See https://github.com/bulletmark/libinput-gestures
  cd $HOME
  # Add user to input group.
  sudo gpasswd -a $USER input
  echo "Added user to input group, typically need to relogin after this step."
  read
  # Install requirements.
  sudo apt install libinput-tools
  git clone https://github.com/bulletmark/libinput-gestures.git
  cd libinput-gestures
  git pull origin master
  sudo make install

  libinput-gestures-setup autostart
  libinput-gestures-setup start
}

function install_shfmt_with_go() {
  GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
}

function setup_git() {
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

function everystall() { # Run all installation functions.
  install_fns=$(awk '/^function install_/{ print substr($2, 1, length($2) - 2)}' $0)
  printf "The following functions will be run, in the order specified here:"
  printf "\n\n$install_fns\n\n"

  for install_fn in $install_fns; do
    printf "\n\n$install_fn\n\n"
    echo -n "Run this? (y/n) "
    read answer
    if echo "$answer" | grep -iq "^n"; then
      continue
    fi
    cd $dir
    $install_fn
    printf "\n\n"
  done
}

function help() {
  printf "\n"
  echo "Usage: do <function>"
  printf "\n"
  echo "Valid functions:"
  printf "\n"
  awk '/^function /{s = ""; for (i = 4; i <= NF; i++) s = s $i " "; printf("%40s   %s\n",substr($2, 1, length($2) - 2), s)}' $0
}

mkdir -p ${backup_dir}
cd $dir
if [ "_$1" = "_" ]; then
  fn=$(
    awk '/^function /{s = ""; for (i = 4; i <= NF; i++) s = s $i " "; printf("%40s   %s\n",substr($2, 1, length($2) - 2), s)}' $0 | fzf | awk '{print $1;}'
  )
  "$fn"
else
  # TODO: Check if the function exists.
  "$@"
fi
