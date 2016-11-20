#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/config.sh

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
  done < $dir/$packages_list
  printf "\n\n"
  sudo apt-get update
  sudo apt-get install $packages
fi
