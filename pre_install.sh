#!/bin/bash

# Pre-install setup. This script is called by install.sh
# Append lines to this file for any pre-installation
# tasks, like adding package repositories.

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

confirm sudo add-apt-repository ppa:graphics-drivers/ppa
confirm sudo add-apt-repository ppa:lexical/hwe-wireless
confirm sudo add-apt-repository ppa:fish-shell/release-2
confirm sudo add-apt-repository ppa:bit-team/stable
confirm sudo add-apt-repository ppa:neovim-ppa/unstable
