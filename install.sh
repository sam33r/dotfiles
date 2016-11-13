#!/bin/bash

# Configuration
#---------------------------------------------------------------

# Path of this (dotfiles) directory.
dir=$HOME/dotfiles            

# Where to backup any existing dotfiles before linking to new
# dotfiles.
backup_dir=$HOME/dotfiles_backup/`date +%s`

# dotfiles config file.
# This is a dumber-than-csv file, each line should be of the form
# <Original Config File Path>,<Path within the ${dir} directory>
dotfiles_config="dotfiles.csv"


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


while IFS=, read config_path dotfile_path
do
  printf "\n\n"
  read -p "Install to ${config_path} (y/n)? " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    printf "\nSkipping ${config_path}\n"
    continue
  fi
  printf "\n${config_path}"
  printf "\n ⇒ ${backup_dir}"
  mv "${config_path}" "${backup_dir}"/"${dotfile_path}" 2>/dev/null
  printf "\n ← ${dir}/${dotfile_path}\n"
  ln -fs "${dir}"/"${dotfile_path}" "${config_path}"
done < $dotfiles_config
