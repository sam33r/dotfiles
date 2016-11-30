#!/bin/bash

# Script to migrate a dotfile into the dotfiles folder.

set -e


dpath="$(cd "$(dirname "$0")" && pwd)"

echo "Enter source file path (relative to $HOME):"
printf $HOME/
read src_path

echo "Enter destination path:"
printf $dpath/
read dest_path

echo "Moving $HOME/$src_path to $dpath/$dest_path"
mv $HOME/$src_path $dpath/$dest_path

echo "Adding to dotfiles config"
echo \$HOME/$src_path,$dest_path >> $dpath/dotfiles.csv

sort $dir/$dotfiles_list -o $dir/$dotfiles_list


echo "Linking $HOME/$src_path to $dpath/$dest_path"
ln -fs $dpath/$dest_path $HOME/$src_path

echo "Done."
