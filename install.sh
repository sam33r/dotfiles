#!/bin/bash

# Configuration
#---------------------------------------------------------------

# Path of this (dotfiles) directory.
dir=$HOME/dotfiles            
# Where to backup any existing dotfiles before linking to new
# dotfiles.
backup_dir=$HOME/dotfiles_old

# Map of dotfile path to its name within the dotfiles folder.
# Add a new entry here for each new file.
declare -A dotfiles=(
        ["$HOME/.bashrc"]="bashrc"
        ["$HOME/.bash_aliases"]="bash_aliases"
        ["$HOME/.vimrc"]="vimrc"
        ["$HOME/.config/liquidpromtrc"]="liquidpromptrc"
        ["$HOME/.xmonad/xmonad.hs"]="xmonad.hs"
        ["$HOME/.config/fish/functions/fish_prompt.fish"]="fish/fish_prompt.fish"
        ["$HOME/.config/fish/functions/apps.fish"]="fish/apps.fish"
        ["$HOME/.config/fish/functions/l.fish"]="fish/l.fish"
        ["$HOME/.config/fish/config.fish"]="fish/config.fish"
        ["$HOME/.config/redshift.conf"]="redshift.conf"
)

#---------------------------------------------------------------

echo "Creating $backup_dir"
mkdir -p $backup_dir

echo "Changing to the $dir directory"
cd $dir

read -p "Backup is best-effort and fails silently. Proceed (y/n)? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
            exit 1
fi

# Move existing files to backup_dir, and then create symlinks.
for d_path in "${!dotfiles[@]}"; do
  printf "\n\n"
  read -p "Install to ${d_path} (y/n)? " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    printf "\nSkipping ${d_path}\n"
    continue
  fi
  printf "\n${d_path}"
  printf "\n ⇒ ${backup_dir}"
  mv "${d_path}" "${backup_dir}"/"${dotfiles[${d_path}]}" 2>/dev/null
  printf "\n → ${dir}/${dotfiles[${d_path}]}\n"
  ln -fs "${dir}"/"${dotfiles[${d_path}]}" "${d_path}"
done
