#!/bin/bash

# Configuration
#---------------------------------------------------------------

# Where to backup any existing dotfiles before linking to new
# dotfiles.
backup_dir=$HOME/dotfiles_backup/`date +%s`

# dotfiles config file.
# This is a dumber-than-csv file, each line should be of the form
# <Original Config File Path>,<Path within the ${dir} directory>
dotfiles_list="dotfiles.csv" 

# List of packages to install.
# Each line should be of the format <package_name>,<description>
packages_list="packages.csv"
#---------------------------------------------------------------
