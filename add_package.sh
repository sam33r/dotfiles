#!/bin/bash

# Script to add a package to packages list, and immediately install
# it on the local machine.

set -e

# Directory of this project.
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $dir/config.sh

echo "Package: "
read package

printf "\n\n"

echo "Purpose: "
read description


sudo apt-get install $package

echo "Installed package, now adding to registry."
echo "$package,$description" >> $dir/$packages_list
sort $dir/$packages_list -o $dir/$packages_list


echo "Done."
