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
dotfiles_list="$dir/dotfiles.csv" 

# List of packages to install.
# Each line should be of the format <package_name>,<description>
packages_list="$dir/packages.csv"
#---------------------------------------------------------------

echo "Creating $backup_dir"
mkdir -p $backup_dir

echo "Changing to the $dir directory"
cd $dir

# Run pre-install script
read -p "Run pre-install script (y/n)? " -n 1 -r </dev/tty 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  source pre_install.sh
fi

# Install packages
printf "\n\n"
read -p "Install packages (y/n)? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  packages=""
  while IFS=, read package description
  do
    printf "\n\n$package : $description\n"
    read -p "Install (y/n)? " -n 1 -r </dev/tty
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      packages+=" $package"
    fi
  done < $packages_list
  printf "\n\n"
  sudo apt-get update
  sudo apt-get install $packages
fi

printf "\n\n"
read -p "Backup is best-effort and fails silently. Proceed (y/n)? " -n 1 -r </dev/tty
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  exit 1
fi

while IFS=, read config_path dotfile_path
do
  printf "\n\n"
  read -p "Install to ${config_path} (y/n)? " -n 1 -r </dev/tty
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    printf "\nSkipping ${config_path}\n"
    continue
  fi
  # Expand any env variables in the config.
  cpath=$(eval echo $config_path)
  dpath=$(eval echo $dotfile_path)
  
  printf "\n${cpath}"
  printf "\n ⇒ ${backup_dir}"
  mv "${cpath}" "${backup_dir}"/"${dpath}" 2>/dev/null
  printf "\n ← ${dir}/${dpath}\n"
  mkdir -p `dirname ${cpath}`
  ln -fs "${dir}"/"${dpath}" "${cpath}"
done < $dotfiles_list

# Run post-install script
printf "\n\n"
read -p "Run post-install script (y/n)? " -n 1 -r </dev/tty 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  printf "\n\n"
  source post_install.sh
fi
