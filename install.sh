#!/bin/bash

# Directory of this project.
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $dir/config.sh

echo "Changing to the $dir directory"
cd $dir

echo "Creating $backup_dir"
mkdir -p $backup_dir

# Run pre-install script
read -p "Run pre-install script (y/n)? " -n 1 -r </dev/tty 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  . $dir/pre_install.sh
fi

# Install packages
. $dir/install_packages.sh

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
  . $dir/post_install.sh
fi
