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

ln -s $HOME/.vim $HOME/.config/nvim
ln -s $HOME/.vimrc $HOME/.config/nvim/init.vim

echo "Content of /usr/share/xsessions/xmonad.desktop:"
cat /usr/share/xsessions/xmonad.desktop
echo "Make sure Exec links to your start xmonad file."
