#!/bin/bash

# Configuration
#---------------------------------------------------------------

# Path of this (dotfiles) directory.
dir=$HOME/dotfiles            
# Where to backup any existing dotfiles before linking to new
# dotfiles.
backup_dir=$HOME/dotfiles_old

# Map of dotflie path to its name within the dotfiles folder.
# Add a new entry here for each new file.
declare -A dotfiles=(
        ["$HOME/.bashrc"]="bashrc"
        ["$HOME/.bash_aliases"]="bash_aliases"
        ["$HOME/.vimrc"]="vimrc"
        ["$HOME/.config/liquidpromtrc"]="liquidpromptrc"
        ["$HOME/.xmonad/xmonad.hs"]="xmonad.hs"
)

#---------------------------------------------------------------

echo "Creating $backup_dir"
mkdir -p $backup_dir

echo "Changing to the $dir directory"
cd $dir

# Move existing files to backup_dir, and then create symlinks.
for d_path in "${!dotfiles[@]}"; do
        printf "\nMoving ${d_path} to ${backup_dir}."
        printf "This will fail if the file does not exist or is already a link.\n"
        mv "${d_path}" "${backup_dir}"/"${dotfiles[${d_path}]}"
        printf "\nLinking ${d_path} to ${dir}/${dotfiles[${d_path}]}.\n"
        ln -fs "${dir}"/"${dotfiles[${d_path}]}" "${d_path}"
done
