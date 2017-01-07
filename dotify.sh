#!/bin/bash

# Script to migrate a dotfile into the dotfiles folder.

set -e

dir="$(cd "$(dirname "$0")" && pwd)"
source $dir/config.sh

echo "Current working directory is:"
echo $PWD

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
